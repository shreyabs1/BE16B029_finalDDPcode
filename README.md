# BE16B029_finalDDPcode
Translation of T1 brain MR image to T2 brain MR image and vice versa using Generative Adversarial Network

Dataset used in this thesis is MICCAI BRATS 2020 and CrossMoDA 2020 dataset.
The raw image data in NIfTI (.nii.gz) is in a 3d image, "preprocessing.m" algorithm written in MATLAB has been implemented on each NIfTI file individually. This algorithm rotates the data in the direction we chose, and slice by slice each image is saved in the png format.
Some of the slices contain few pixels while some are black, these images should be excluded from the GAN training as they do not have enough information about the brain structure.

For the translation task proposed CycleGAN model "BE16B029_DDPcode.ipynb" is written in Keras with the Tensorflow backend. To get the translated images this algorithm is applied on slices we obtained after the preprocessing step.
All our experiments are done on the Nvidia 12 GB Tesla K80 GPU and the training time for cycleGAN is 425 seconds/epoch.
