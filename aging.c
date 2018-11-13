
#include <aging.h>

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

     char *const_string = "abcdefghijklmnopqrstuvwxyzPQLAMZNXKSOWEIDJCBVFRTGHUY"

     int len = strlen(const_string);

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

     return;
}


int main(int argc, char **argv) {

    srand(time(NULL));

    aging = malloc(sizeof(struct aging_params));
 
    if(!aging) {
        return 1;
    }

    int c = 0;

    while(( c = getopt(argc, argv, "d:D:F:l")) != -1) {

        switch(c) {

            case 'd':
                    aging->work_dir = optarg;
                    break;

            case 'D':
                    aging->sub_dir_cnt = atoi(optarg);
                    break;

            case 'F':
                    aging->file_cnt = atoi(optarg);
                    break;

            case 'l':
                    aging->dir_lvl = atoi(optarg);
                    break;

            default:
                    printf("Usage:\n");
                    printf("\t d -> Work directory");
                    pritnf("\t D -> Number of directories\n");
                    printf("\t F -> Number of files in each directory\n");
                    printf("\t l -> Levels of directories\n");

        }

    }


    root_entry = malloc( sizeof(struct dir_entry) );
 
    if(!root_entry) {
        printf("Unable to allocate space for root_entry");
        return 1;
    }

    root_entry->path = malloc(strlen(aging->work_dir));

    


    return 0

}
