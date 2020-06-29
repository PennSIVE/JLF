#!/usr/bin/env Rscript
library(argparser)
library(ANTsR)
library(extrantsr)
library(neurobase)

# create a parser
p <- arg_parser("Run JLF")
# add command line arguments
p <- add_argument(p, "--out", help = "Output filename", default = "/out")
# parse the command line arguments
argv <- parse_args(p)

target = readnii("/N4_T1_strip.nii.gz")
index <- as.numeric(Sys.getenv("INDEX"))
message(paste("Running iteration", index))

oasis = paste0("/atlas/OASIS-TRT-20-", index, "/rai_t1weighted_brain.nii.gz")
thalamus = paste0("/atlas/OASIS-TRT-20-", index, "/rai_thalamus_atlas_20-", index, ".nii.gz")

# Register oasis image to target image
atlas_to_image = registration(filename = oasis,
                template.file = target,
               typeofTransform = "SyN", remove.warp = FALSE)
# Register atlases and ventricles
oasis_reg = antsApplyTransforms(fixed = oro2ants(target), moving = oro2ants(readnii(oasis)),
            transformlist = atlas_to_image$fwdtransforms, interpolator = "nearestNeighbor")
oasis_thalamus = antsApplyTransforms(fixed = oro2ants(target), moving = oro2ants(readnii(thalamus)),
               transformlist = atlas_to_image$fwdtransforms, interpolator = "nearestNeighbor")

antsImageWrite(oasis_reg, paste0(argv$out, "/oasis_to_t1/_jlf_oasisreg", index, ".nii.gz"))
antsImageWrite(oasis_thalamus, paste0(argv$out, "/oasis_thalamus_to_t1/_jlf_oasisreg", index, "_thalamus.nii.gz"))
