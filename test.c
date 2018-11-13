#include <stdio.h>
#include <inttypes.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>



void gen_name(int is_dir, char *name) {


     char *ts;
     char *rand_str;


     struct timeval val;
     gettimeofday(&val, NULL);

     unsigned long t_usec = 1000000 * val.tv_sec + val.tv_usec;


     int n = snprintf(NULL, 0, "%lu", t_usec);
     ts = malloc((n+1) * sizeof(char));

     int k = snprintf(ts, n+1, "%lu", t_usec);


     if(is_dir) {

       name = ts;

       return;

     }

     char *const_string = "abcdefghijklmnopqrstuvwxyzPQLAMZNXKSOWEIDJCBVFRTGHUY";

     int len = strlen(const_string);
 
     if(len == 0)
         return;

     rand_str = malloc((12 + k) * sizeof(char));

     int i, idx;
     //char cval;
     for(i = 0; i < 11; i++) {
         idx = rand() % len;
         rand_str[i] = const_string[idx];
     }

     rand_str[11] = '_';

     //int file_nm_len = k + 11;

     for(i = 12, idx = 0; i < (12 + k); i++) {
         rand_str[i] = (char) ts[idx];
         idx++;
     }

     name = rand_str;

     printf("GEN: Rand_Str: %s\n", rand_str);
     printf("GEN: Name: %s\n", name);

     return;
}


int main() {


    char *name;

    srand(time(NULL));

    gen_name(0, name);

    printf("Name: %s\n", name);

    return 0;
}
