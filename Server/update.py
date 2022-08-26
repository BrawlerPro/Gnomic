import subprocess
import time

program_list = ['parserFile.py', 'identifier.py', 'findRelevant.py', 'pushToSheet.py']

for program in program_list:
    print("START!!!!!!!!!!!!!!")
    subprocess.call(['py', program])
    time.sleep(3)
    print("FINISHED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
