ARITHMETIC_RANGE    = range(0,   4)
BRANCH_RANGE        = range(4,   8)
MEM_RANGE           = range(8,  10)
PSEUDO_RANGE        = range(10, 13)
BRANCH_OFFSET_RANGE = range(-2048, 2048)
MOV_IMM_RANGE       = range(-128, 128)
MEM_OFFSET_RANGE    = range(-32, 32)

INSN_IDS = {
    "add"  :  0,
    "sub"  :  1,
    "mul"  :  2,
    "mov"  :  3,
    "b"    :  4,
    "beq"  :  5,
    "bneq" :  6,
    "blt"  :  7,
    "lr"   :  8,
    "sr"   :  9,
    "cmp"  : 10,
    "nop"  : 11,
    "movr" : 12 
}

OPCODES = {
    "add"  : "0000",
    "sub"  : "0001",
    "mul"  : "0010",
    "mov"  : "0011",
    "b"    : "0100",
    "beq"  : "0101",
    "bneq" : "0110",
    "blt"  : "0111",
    "lr"   :   "10",
    "sr"   :   "11",
    "cmp"  : "0001",
    "movr" : "0000",
    "nop"  : "0000"
}

REG_CODES = {
    "xzr"      : "0000",
    "x0"       : "0001",
    "x1"       : "0010",
    "x2"       : "0011",
    "x3"       : "0100",
    "x4"       : "0101",
    "x5"       : "0110",
    "x6"       : "0111",
    "x7"       : "1000",
    "sp"       : "1001",
    "pc"       : "1010",
    "aluflags" : "1011"
}

class Assembler:    
    def __init__(self, path):
        src_file = open(path, 'r')
        self.mnemos = src_file.read().split('\n')
        self.mnemos = [line for line in self.mnemos if line != '']
        src_file.close()

    def reg_name_to_code(self, reg_name):
        if reg_name == "pc":
            raise "Line %d: using pc register is prohibited\n" % self.line_num
        elif reg_name == "aluflags":
            raise "Line %d: using aluflags register is prohibited\n" % self.line_num
        else:
            if reg_name not in REG_CODES:
                raise "Line %d: unexpected register %s\n" % (self.line_num, reg_name)
            return REG_CODES[reg_name]

    def insn_name_to_id_and_code(self, insn_name):
        if insn_name not in INSN_IDS:
            raise "Line %d: unexpected instruction %s\n" % (self.line_num, insn_name)
        insn_id = INSN_IDS[insn_name]
        opcode  = OPCODES[insn_name]
        return insn_id, opcode
    
    def process_arithmetic(self, mnemo, insn_id, opcode):
        if insn_id != INSN_IDS["mov"]:
            print("Type: arithmetic")
            if len(mnemo) != 4:
                raise "Line %d: incorrect operands\n" % self.line_num
            if mnemo[1] not in REG_CODES or \
                mnemo[2] not in REG_CODES or \
                mnemo[3] not in REG_CODES :
                raise "Line %d: incorrect operands\n" % self.line_num
            dst = REG_CODES[mnemo[1]]
            op1 = REG_CODES[mnemo[2]]
            op2 = REG_CODES[mnemo[3]]
            print("Dst:", mnemo[1], "\tcode:", dst)
            print("Op1:", mnemo[2], "\tcode:", op1)
            print("Op2:", mnemo[3], "\tcode:", op2)
            insn_code = hex(int(opcode + dst + op1 + op2, base=2))
        else:
            print("Type: arithmetic")
            if len(mnemo) != 3:
                raise "Line %d: incorrect operands\n" % self.line_num
            if mnemo[1] not in REG_CODES:
                raise "Line %d: incorrect operands\n" % self.line_num
            try:
                imm = int(mnemo[2])
            except:
                raise "Line %d: incorrect immediate\n" % self.line_num
            if imm not in MOV_IMM_RANGE:
                raise "Line %d: incorrect immediate\n" % self.line_num
            dst = REG_CODES[mnemo[1]]
            op1 = "{:0>8}".format(bin(imm)[2:]) if imm >= 0 else "{:0>8}".format(bin(256+imm)[2:])
            print("Dst:", mnemo[1], "\tcode:", dst)
            print("Op1:", mnemo[2], "\tbin immediate:", op1)
            insn_code = hex(int(opcode + dst + op1, base=2))
        return insn_code

    def process_memory(self, mnemo, insn_id, opcode):
        print("Type: memory access")
        if len(mnemo) != 4:
            raise "Line %d: incorrect operands\n" % self.line_num
        if mnemo[1] not in REG_CODES or \
            mnemo[2] not in REG_CODES:
            raise "Line %d: incorrect operands\n" % self.line_num
        op1 = REG_CODES[mnemo[1]]
        op2 = REG_CODES[mnemo[2]]
        print("Op1:", mnemo[1], "\tcode:", op1)
        print("Op2:", mnemo[2], "\tcode:", op2)
        try:
            offset = int(mnemo[3])
        except:
            raise "Line %d: incorrect offset\n" % self.line_num
        if offset not in MEM_OFFSET_RANGE:
            raise "Line %d: offset is too long\n" % self.line_num
        op3 = "{:0>6}".format(bin(offset)[2:]) if offset >= 0 else "{:0>6}".format(bin(64+offset)[2:])
        print("Offset:", mnemo[3], "\tbin offset:", op3)
        insn_code = hex(int(opcode + op1 + op2 + op3, base=2))
        return insn_code

    def process_branch(self, mnemo, insn_id, opcode, pc):
        print("Type: branch")
        if len(mnemo) != 2:
            raise "Line %d: incorrect operands\n" % self.line_num
        print("Op:", mnemo[1])
        try:
            offset = int(mnemo[1])
        except:
            if mnemo[1] not in self.labels_table:
                raise "Line %d: incorrect label\n" % self.line_num
            offset = self.labels_table[mnemo[1]] - pc
        print("Offset:", offset)
        if offset not in BRANCH_OFFSET_RANGE:
                raise "Line %d: too long offset\n" % self.line_num

        if offset > 0:
            offset_s = "{:0>12}".format(bin(offset)[2:])
        elif offset < 0:
            offset_s = "{:0>12}".format(bin(4096+offset)[2:])

        print("Offset bin:", offset_s)
        insn_code = hex(int(opcode + offset_s, base=2))
        return insn_code

    def process_pseudo(self, mnemo, insn_id, opcode):
        if mnemo[0] == "nop":
            if len(mnemo) != 1:
                raise "Line %d: nop takes no operands\n"
            return self.process_arithmetic(['add','xzr','xzr','xzr'], insn_id, opcode)
        if mnemo[0] == "movr":
            if len(mnemo) != 3:
                raise "Line %d: incorrect operands\n"
            if mnemo[1] not in REG_CODES or \
               mnemo[2] not in REG_CODES:
                raise "Line %d: incorrect operands\n"
            return self.process_arithmetic(['add', mnemo[1], mnemo[2], 'xzr'], insn_id, opcode)
        if mnemo[0] == "cmp":
            if len(mnemo) != 3:
                raise "Line %d: incorrect operands\n"
            if mnemo[1] not in REG_CODES or \
               mnemo[2] not in REG_CODES:
                raise "Line %d: incorrect operands\n"
            return self.process_arithmetic(['sub', 'xzr', mnemo[1], mnemo[2]], insn_id, opcode)
    
    def process_labels(self):
        pc = 0
        labels_table = dict()
        for self.line_num, mnemo in enumerate(self.mnemos):
            if mnemo.find(":") != -1 :
                mnemo = mnemo.replace(":", "")
                mnemo_splitted = mnemo.split()
                if len(mnemo_splitted) > 1:
                    raise "Line %d: label name should not contain white spaces\n"
                label = mnemo_splitted[0]
                if mnemo in labels_table:
                    raise "Line %d: label name appears more than once\n"
                labels_table[label] = pc 
            else:
                pc += 1
        
        if len(labels_table) == 0:
            print("No labels")
        else:
            print(len(labels_table), "labels were met")
            print("label name : pc")
            for label in labels_table:
                print(label, ":", labels_table[label])

        print("\n\n")
        return labels_table

    def compile(self):

        self.insns = []
        self.labels_table = self.process_labels()

        pc = 0        
        for self.line_num, mnemo in enumerate(self.mnemos):
            if mnemo.find(":") == -1:
                print(self.line_num, ":", mnemo)
                print("PC :", pc)
                mnemo = mnemo.replace(",", "").split()
                insn_id, opcode = self.insn_name_to_id_and_code(mnemo[0])
                print("Insn ID:", insn_id)
                print("Opcode:", opcode)
                if insn_id in ARITHMETIC_RANGE:
                    insn_code = self.process_arithmetic(mnemo, insn_id, opcode)
                elif insn_id in BRANCH_RANGE:
                    insn_code = self.process_branch(mnemo, insn_id, opcode, pc)
                elif insn_id in MEM_RANGE:
                    insn_code = self.process_memory(mnemo, insn_id, opcode)
                elif insn_id in PSEUDO_RANGE:
                    insn_code = self.process_pseudo(mnemo, insn_id, opcode)
                print("Insn bin:", "{:0>16}".format(bin(int(insn_code, base=16))[2:]))
                print("Insn hex:", insn_code)
                pc += 1
                self.insns.append(insn_code[2:])
                print("\n\n")
