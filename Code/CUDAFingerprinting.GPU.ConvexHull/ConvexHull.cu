#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>
#include "ImageLoading.cuh"
#include "ConvexHull.cuh"

// [start] Convex hull itself

Point firstPoint;

int comparator(const void *a, const void *b)
{
	Point A = *(Point *)a;
	Point B = *(Point *)b;

	return
		rotate(firstPoint, A, B) > 0 ? -1 :
		A.x == B.x && A.y == B.y ? 0 :
		1;
}

void setFirstPoint(Point* points, int pointsLength)
{
	if (!pointsLength)
	{
		printf("Convex hull invalid input: 0 points; exiting\n");
		exit(EXIT_FAILURE);
	}

	firstPoint = points[0];
	
	for (int i = 0; i < pointsLength; i++)
	{
		if (points[i].x < firstPoint.x)
		{
			firstPoint = points[i];
		}
	}
}

void buildHull(Point* points, int pointsLength, Point* hull, int *hullLength)
{
	if (pointsLength < 2)
	{
		printf("Convex hull build invalid input: less than 2 points; exiting\n");
		exit(EXIT_FAILURE);
	}

	hull[0] = points[0];
	hull[1] = points[1];

	Point top = points[1];
	Point nextToTop = points[0];
	int curNextToTopIndex = 0;

	int _hullLength = 2;

	for (int i = 2; i < pointsLength; i++)
	{
		while (rotate(nextToTop, top, points[i]) < 0)
		{
			_hullLength--;
			top = nextToTop;
			nextToTop = points[--curNextToTopIndex];
		}

		hull[_hullLength++] = points[i];
		nextToTop = top;
		curNextToTopIndex++;
		top = points[i];
	}

	*hullLength = _hullLength;
}

void getConvexHull(Point* points, int pointsLength, Point* hull, int *hullLength)
{
	setFirstPoint(points, pointsLength);
	qsort(points, pointsLength, sizeof(Point), comparator);
	buildHull(points, pointsLength, hull, hullLength);
}

// [end] Convex hull itself


// [start] Convex hull field filling

// Algorithm for any convex area (and even for some not convex)
bool isPointInsideHull(Point point, Point* hull, int hullLength)
{
	int n = hullLength;

	if (n < 2)
	{
		printf("isPointInsideHull invalid input: less than 2 points; exiting\n");
		exit(EXIT_FAILURE);
	}

	// If point is outside the segment (n - 1, 0, 1), it's always outside the hull
	if (rotate(hull[0], hull[1], point) < 0 || rotate(hull[0], hull[n - 1], point) > 0)
	{
		return false;
	}

	// Binary search
	int p = 1, r = n - 1;
	while (r - p > 1)
	{
		int q = (p + r) / 2;
		if (rotate(hull[0], hull[q], point) < 0)
		{
			r = q;
		}
		else
		{
			p = q;
		}
	}

	return !intersect(hull[0], point, hull[p], hull[r]);
}

bool** getFieldFilling(int rows, int columns, Point* hull, int hullLength)
{
	bool** field = (bool**)malloc(rows * sizeof(bool *));
	for (int i = 0; i < rows; i++)
	{
		field[i] = (bool *)malloc(columns * sizeof(bool));
	}

	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < columns; j++)
		{
			Point curPoint((float)i, (float)j);

			field[i][j] = isPointInsideHull(curPoint, hull, hullLength) ? true : false;
		}
	}

	return field;
}

// [end] Convex hull field filling