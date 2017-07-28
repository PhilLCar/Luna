#include <stdarg.h>
#include <stdio.h>

double average(int count, ...)
{
    va_list ap;
    int j;
    double sum = 0;

    va_start(ap, count); /* Requires the last fixed parameter (to get the address) */
    for (j = 0; j < count; j++) {
        sum += va_arg(ap, int); /* Increments ap to the next argument. */
    }
    va_end(ap);

    return sum / count;
}

int main(int argc, char const *argv[])
{
	printf("%f\n", average(3, 1, 2, 3) );
	return 0;
}
