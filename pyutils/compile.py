from asm import Assembler
PROJECT_DIR = "/home/vadimpy/Documents/fpga/iocomp"
asm = Assembler(PROJECT_DIR + "/pyutils/code.s")
asm.compile()
mem_img = "".join([insn_code + " " for insn_code in asm.insns])
mem_img_file = open(PROJECT_DIR + "/pyutils/rom_image.mem", "w+")
mem_img_file.write(mem_img)
mem_img_file.close()