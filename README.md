# JLF
Wrapper for running ANTS joint label fusion. Reads in an image (`--target`), registers to atlases and/or runs `antsJointFusion`, depending on if `--type` is `preprocessing`, `processing`, or `both` (`both` will run `antsJointFusion` after checking all atlas registration completed by counting files)

Full usage:
```
usage: docker run pennsive/jlf [--] [--help] [--opts OPTS] [--out OUT]
       [--target TARGET] [--type TYPE]

flags:
  -h, --help    show this help message and exit

optional arguments:
  -x, --opts    RDS file containing argument values
  -o, --out     Output directory [default: /out]
  -t, --target  Target filename [default: /N4_T1_strip.nii.gz]
  --type        preprocessing = atlas generation, processing =
                antsJointFusion, both = do both, checking file counts
                to know when to do processing [default: both]
```