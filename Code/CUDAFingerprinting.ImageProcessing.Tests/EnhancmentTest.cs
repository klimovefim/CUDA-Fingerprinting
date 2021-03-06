﻿using CUDAFingerprinting.Common;
using CUDAFingerprinting.Common.OrientationField;
using CUDAFingerprinting.ImageProcessing.GaborEnhancement;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CUDAFingerprinting.ImageProcessing.Tests
{
    [TestClass]
    public class EnhancmentTest
    {
        [TestMethod]
        public void ImageEnhancmentTest()
        {
            var bmp = Resources.SampleFinger;
            double[,] imgDoubles = ImageHelper.LoadImage<double>(bmp);

            imgDoubles.DoNormalization(100, 100);

            int[,] imgInts = imgDoubles.Select2D((x => (int)x));
            OrientationField orf = new OrientationField(imgInts, 16);
            double[,] orient = orf.GetOrientationMatrix(imgInts.GetLength(0), imgInts.GetLength(1));

            var freqMatrx = LocalRidgeFrequency.GetFrequencies(imgDoubles, orient);

            var res = ImageEnhancement.Enhance(imgDoubles, orient, freqMatrx, 32, 8);
            var bmp2 = ImageHelper.SaveArrayToBitmap(res);
            bmp2.Save("001.bmp", ImageHelper.GetImageFormatFromExtension("009.bmp"));
        }
    }
}
