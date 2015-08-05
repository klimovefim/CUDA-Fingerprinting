﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CUDAFingerprinting.Common;

namespace CUDAFingerprinting.FeatureExtraction.Minutiae
{
    class FengMinutiaDescriptor
    {
        private unsafe static void Transformate(Minutia[] desc, Minutia point1, Minutia point2)
        {
            int i;
            float angle = point2.Angle - point1.Angle;
            for(i = 0; i < desc.Length; i++)
            {
                desc[i].X = (desc[i].X - point1.X) * (int)Math.Cos(angle) + 
                            (desc[i].Y - point1.Y) * (int)Math.Sin(angle) + point2.X;
                desc[i].Y = - (desc[i].X - point1.X) * (int)Math.Sin(angle) +
                            (desc[i].Y - point1.Y) * (int)Math.Cos(angle) + point2.Y;
                desc[i].Angle -= angle;
            }
        }
        public static float MinutiaCompare(Minutia[] desc1, Minutia point1, Minutia[] desc2, Minutia point2, float radius)
        {
            int i, j;
            float eps = 0.1;
            Minutia[] desc_;
            for (i = 0; i < desc1.Length; i++)
            {
                for (j = 0; j < desc2.Length; i++)
                {
                    
                }
            }

                    return 0.0F;          
        }
    }
}