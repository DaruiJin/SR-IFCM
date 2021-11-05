## SR-IFCM
## Table of Contents

- [Background](#background)
- [Usage](#usage)
- [Badge](#badge)
- [Citation](#Citation)
- [License](#license)

## Background

This is the matlab implementation of the paper "Integrating Structural Symmetry and Local Homoplasy Information in Intuitionistic Fuzzy Clustering for Infrared Pedestrian Segmentation". The methodology is proposed to solve the problems of interferential background, boundary uncertainty and noises in infrared pedestrian segmentation. It achieves a mean error rate of 0.2037% in the corresponding infrared pedestrian dataset containing 500 long wavelength infrared radiation (LWIR) pedestrian images paired with pixelwise annotation. All the experiments are performed under the environment of Intel Core i5-6500 CPU, 3.20 GHz, with 12-GB RAM and a single NVIDIA GTX1080 GPU with 8-GB RAM.

## Usage

Please run [main.m](main.m) to get the segmentation results, which would be automatically saved in [result](result) folder. Before that, remember to put the image to be segmented in [data](data) folder. 

## Badge

[![Author](https://img.shields.io/badge/Author-DaruiJin-red.svg "Author")](https://www.researchgate.net/profile/Darui-Jin "Author")
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Paper](https://img.shields.io/badge/Paper-SRIFCM-green.svg)](https://ieeexplore.ieee.org/document/8818359 "Paper")
[![Lab](https://img.shields.io/badge/Lab-BUAA-purple.svg)](http://xzbai.buaa.edu.cn/publication.html "Paper")

## Citation

If you use this code for your research, please cite our paper.

```
@article{SR-IFCM,
title={Integrating Structural Symmetry and Local Homoplasy Information in Intuitionistic Fuzzy Clustering for Infrared Pedestrian Segmentation},
  author={Darui Jin, Xiangzhi Bai and Yingfan Wang},
  Journal={IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  volume={51},
  pages={4365-4378},
  year={2021},
  publisher={IEEE}
 }
 ```
 
 ## License
 [MIT](LICENSE)
