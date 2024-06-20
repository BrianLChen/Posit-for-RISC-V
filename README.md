# GDP33 Posit for RISC-V
Implement Posit Processing Unit on CV32E40P

[posit standard-2](https://posithub.org/docs/posit_standard-2.pdf)  
[cv32e40p main](https://github.com/openhwgroup/cv32e40p/tree/master)

-----------------------------------------------------------------------

To commit changes: 
use "git add <filename>" to add to commit
use "git restore <filename> --staged" to remove from commit
Then "git commit", the first line is the title of the commit, then two lines down list changes starting with "*"

e.g: 
New Commit

* 1 change
* 2 change

Create new branch: "git checkout -b <branch_name>"

Push to remote branch: whilst on local branch "git push origin <remote_name>:<local_name>"

Then go to github.com and create pull request if needed, and ask for reviewer

## Instructions
Clone the original CV32E40P repo
```
git clone https://github.com/openhwgroup/cv32e40p
cd cv32e40p/ 
git checkout fcd5968

mkdir rtl/ppu
```

Create a new folder under cv32e40p/rtl called ppu, and copy ppu/src (Posit Process Unit) into CV32E40P

Posit-for-RISC-V/ppu/src --> cv32e40p/rtl/ppupp
```
cp -r Posit-for-RISC-V/ppu/src cv32e40p/rtl/ppu
```

backup the original Makefile and cv32e40p_fp_wrapper.sv if needed.
```
cp  Posit-for-RISC-V/ppu/Makefile cv32e40p/example_tb/core/
cp Posit-for-RISC-V/ppu/cv32e40p_fp_wrapper.sv cv32e40p/example_tb/core/
```

Don't forget to set the uvm environment for cv32e40p first. You may also need to change some content in the Makefile to set location of gcc tool chain.
### Test Program
## Result
![Test conpare with IEEE 754 Float](/Picture/Forward_Compare_large_text.png)
