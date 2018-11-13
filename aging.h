
#include <stdio.h>
#include <inttypes.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

struct aging_params {

    char *work_dir;
    int  sub_dir_cnt;
    int  file_cnt;
    int  dir_lvl;
};

struct dir_entry {
    char *path;                 // path to parent directory + name of directory
    struct dir_entry *next;     // link to next dir_entry in the same level
    struct dir_entry *child;    // link to child dir_entry (first sub directory)
};

struct aging_params *aging;
struct dir_entry *root_entry;  // work directory
