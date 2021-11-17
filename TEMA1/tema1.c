/* Copyright 2021 Adrian-Valeriu Croitoru */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_INPUT_LINE_SIZE 300

struct Dir;
struct File;

typedef struct Dir{
	char *name;
	struct Dir* parent;
	struct File* head_children_files;
	struct Dir* head_children_dirs;
	struct Dir* next;
} Dir;

typedef struct File {
	char *name;
	struct Dir* parent;
	struct File* next;
} File;

/* the root directory initialization */
Dir *home_malloc() {
	Dir *current_dir = (Dir*)malloc(sizeof(Dir));
	current_dir->name = (char*)malloc(sizeof(char) * 5);
	strcpy(current_dir->name, "home");
	current_dir->parent = NULL;
	current_dir->head_children_files = NULL;
	current_dir->head_children_dirs = NULL;
	current_dir->next = NULL;
}

/* breakes a string into 2 substrings after
   the first occurance of space character */
void sentence_breaker(char *sentence, char *word1, char *word2) {
	int dim_op;
	for (int i = 0; i < strlen(sentence); i++) {
		if (sentence[i] == ' ') {
			strcpy(word2, sentence + i + 1);
			break;
		}
		dim_op = i;
		word1[i] = sentence[i];
	}
	word1[dim_op + 1] = '\0';
}

/* returns 1 if the Dir 'name' exists, 0 if it doesn't
   the_dir - pointer to the Dir called name, or NULL */
int check_existance_dir(Dir *parent, char *name, Dir **the_dir) {
	*the_dir = NULL;
	Dir *check_dir = parent->head_children_dirs;
	while (check_dir) {
		if (!strcmp(check_dir->name, name)) {
			*the_dir = check_dir;
			return 1;
		}
		check_dir = check_dir->next;
	}

	return 0;
}

/* returns 1 if the File 'name' exists, 0 if it doesn't
   the_file - pointer to the File called name, or NULL */
int check_existance_file(Dir *parent, char *name, File **the_file) {
	*the_file = NULL;
	File *check_file = parent->head_children_files;
	while (check_file) {
		if (!strcmp(check_file->name, name)) {
			*the_file = check_file;
			return 1;
		}
		check_file = check_file->next;
	}

	return 0;
}

void touch (Dir* parent, char* name) {
	/* file_garbage and dir_garbage are used just
	   to call the check_existance functions */
	File *file_garbage; Dir *dir_garbage;
	if (check_existance_file(parent, name, &file_garbage) ||
		check_existance_dir(parent, name, &dir_garbage)) {
		printf("File already exists\n");
		return;
	}

	/* the initialization of the new file */
	File *new = (File*)malloc(sizeof(File));
	new->name = (char*)malloc(sizeof(char) * (strlen(name) + 1));
	strcpy(new->name, name);
	new->parent = parent;
	new->next = NULL;

	/* add the new file to the list */
	if (!parent->head_children_files) {
		parent->head_children_files = new;
	} else {
		File *temp = parent->head_children_files;
		while (temp && temp->next) {
			temp = temp->next;
		}
		temp->next = new;
	}
}

void mkdir (Dir* parent, char* name) {
	/* file_garbage and dir_garbage are used just
	   to call the check_existance functions */
	File *file_garbage; Dir *dir_garbage;
	if (check_existance_dir(parent, name, &dir_garbage) ||
		check_existance_file(parent, name, &file_garbage)) {
		printf("Directory already exists\n");
		return;
	}

	/* the initialization of the new directory */
	Dir *new = (Dir*)malloc(sizeof(Dir));
	new->name = (char*)malloc(sizeof(char) * (strlen(name) + 1));
	strcpy(new->name, name);
	new->parent = parent;
	new->head_children_files = NULL;
	new->head_children_dirs = NULL;
	new->next = NULL;

	/* add the new directory to the list */
	if (!parent->head_children_dirs) {
		parent->head_children_dirs = new;
	} else {
		Dir *temp = parent->head_children_dirs;
		while (temp && temp->next) {
			temp = temp->next;
		}
		temp->next = new;
	}
}

void ls (Dir* parent) {
	File *file_cursor = parent->head_children_files;
	Dir *director_cursor = parent->head_children_dirs;

	while(director_cursor) {
		printf("%s\n", director_cursor->name);
		director_cursor = director_cursor->next;
	}

	while(file_cursor) {
		printf("%s\n", file_cursor->name);
		file_cursor = file_cursor->next;
	}
}

void rm (Dir* parent, char* name) {
	File *to_be_removed;
	if (!check_existance_file(parent, name, &to_be_removed)) {
		printf("Could not find the file\n");
		return;
	}

	/* remove the file from the list */
	if (!strcmp(to_be_removed->name, parent->head_children_files->name)) {
		parent->head_children_files = to_be_removed->next;
		to_be_removed->next = NULL;
	} else {
		File *to_be_removed_prev = parent->head_children_files;
		while (to_be_removed_prev && to_be_removed_prev->next) {
		if (!strcmp(to_be_removed_prev->next->name, name)) {
			break;
		}
		to_be_removed_prev = to_be_removed_prev->next;
		}

		to_be_removed_prev->next = to_be_removed->next;
		to_be_removed->next = NULL;
	}

	/* free the file memory */
	free(to_be_removed->name);
	free(to_be_removed);
}

void rmdir (Dir* parent, char* name) {
	Dir *to_be_removed;
	if (!check_existance_dir(parent, name, &to_be_removed)) {
		printf("Could not find the dir\n");
		return;
	}

	/* remove the directory from the list */
	if (!strcmp(to_be_removed->name, parent->head_children_dirs->name)) {
		parent->head_children_dirs = to_be_removed->next;
		to_be_removed->next = NULL;
	} else {
		Dir *to_be_removed_prev = parent->head_children_dirs;
		while (to_be_removed_prev && to_be_removed_prev->next) {
		if (!strcmp(to_be_removed_prev->next->name, name)) {
			break;
		}
		to_be_removed_prev = to_be_removed_prev->next;
		}

		to_be_removed_prev->next = to_be_removed->next;
		to_be_removed->next = NULL;
	}
	
	/* remove and free all the files of to_be_removed directory */
	File *file_to_be_removed = to_be_removed->head_children_files;
	File *file_to_be_removed_cpy;
	while(file_to_be_removed) {
		free(file_to_be_removed->name);
		file_to_be_removed_cpy = file_to_be_removed;
		file_to_be_removed = file_to_be_removed->next;
		free(file_to_be_removed_cpy);
	}

	/* free the directory memory */
	free(to_be_removed->name);
	free(to_be_removed);
}

void cd (Dir** target, char *name) {
	if (!strcmp(name, "..")) {
		if ((*target)->parent) {
			*target = (*target)->parent;
			return;
		}
	} else {
		Dir *director_cursor = (*target)->head_children_dirs;
		while(director_cursor) {
			if (!strcmp(director_cursor->name, name)) {
				*target = director_cursor;
				return;
			}
			director_cursor = director_cursor->next;
		}
		printf("No directories found!\n");
	}
}

char *pwd (Dir* target) {
	Dir *current_dir = target;
	/* path_inversed contains the path as
	   'd3/d2/d1/home/' - it has to be reversed */
	char *path_inversed = (char*)malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
	while (current_dir) {
		strcat(path_inversed, current_dir->name);
		strcat(path_inversed, "/");
		current_dir = current_dir->parent;
	}
	/* the reverse of the above path to bring it to the
	   final shape - '/home/d1/d2/d3' */
	char *path = (char*)malloc(sizeof(char) * (strlen(path_inversed) + 1));
	int cnt = 0;
	for (int i = strlen(path_inversed) - 1; i >= 0; i--) {
		if (path_inversed[i] == '/') {	
			if (cnt) {
				strncpy(path + strlen(path), path_inversed + i + 1, cnt);
			}
			strncpy(path + strlen(path), path_inversed + i, 1);
			cnt = 0;
		} else if (i == 0) {
			cnt++;
			strncpy(path + strlen(path), path_inversed + i, cnt);
		} else {
			cnt++;
		}
	}

	free(path_inversed);

	return path;
}

void stop (Dir* target) {
	if (!target)
		return;

	/* recursively seek each directory and free the memory */
	Dir *dir = target->head_children_dirs;
	while (dir) {
		free(dir->name);

		stop(dir);

		Dir *dir_cpy = dir;
		dir = dir->next;
		free(dir_cpy);
	}

	/* free all the files of a directory */
	File *file = target->head_children_files;
	File *file_cpy;
	while (file) {
		free(file->name);
		file_cpy = file;
		file = file->next;
		free(file_cpy);
	}
}

void tree (Dir* target, int level) {
	if (!target)
		return;

	/* recursively seek each directory and print its name */
	Dir *dir = target->head_children_dirs;
	while (dir) {
		for (int i = 0; i < level * 4; i++) {
			printf(" ");
		}
		printf("%s\n", dir->name);

		tree(dir, level + 1);

		dir = dir->next;
	}

	/* seek all the files of a directory and print them */
	File *file = target->head_children_files;
	while (file) {
		for (int i = 0; i < level * 4; i++) {
			printf(" ");
		}
		printf("%s\n", file->name);
		file = file->next;
	}
}

/* checks if the mv operation is possible, returns -1 otherwise,
   and 0(1) if the mv is on a file(dir) */
int mv_check(Dir *parent, char *oldname, char *newname,
			 File **the_file, Dir **the_dir) {
	/* garbages - used just to call the function check_existance */
	File *garbage_file; Dir *garbage_dir;
	int type = -1;

	if (check_existance_dir(parent, oldname, the_dir)) {
		type = 1;
	} else if(check_existance_file(parent, oldname, the_file)) {
		type = 0;
	}
	if (type == -1) {
		printf("File/Director not found\n");
		return -1;
	}

	if (check_existance_dir(parent, newname, &garbage_dir) ||
		check_existance_file(parent, newname, &garbage_file)) {
		printf("File/Director already exists\n");
		return -1;
	}

	return type;
}

void mv(Dir* parent, char *oldname, char *newname) {
	File *the_file; Dir *the_dir;

	/* 0 for file, 1 for directory */
	int type =  mv_check(parent, oldname, newname, &the_file, &the_dir);
	if (type == -1) {
		return;
	}

	if (type == 0) {  /* mv a file */
		strcpy(the_file->name, newname);

		/* remove the links of the old file */
		if (!strcmp(the_file->name, parent->head_children_files->name)) {
			parent->head_children_files = the_file->next;
			the_file->next = NULL;
		} else {
			File *the_file_prev = parent->head_children_files;
			while (the_file_prev && the_file_prev->next) {
				if (!strcmp(the_file_prev->next->name, newname)) {
					break;
				}
				the_file_prev = the_file_prev->next;
			}

			the_file_prev->next = the_file->next;
			the_file->next = NULL;
		}

		/* add the file at the end of the files list */
		File *new_file = parent->head_children_files;
		while (new_file && new_file->next) {
			new_file = new_file->next;
		}
		if (new_file) {
			new_file->next = the_file;
		} else {
			parent->head_children_files = the_file;
		}
	} else if (type == 1) {  /* mv a directory */
		strcpy(the_dir->name, newname);

		/* remove the links of the old directory */
		if (!strcmp(the_dir->name, parent->head_children_dirs->name)) {
			parent->head_children_dirs = the_dir->next;
			the_dir->next = NULL;
		} else {
			Dir *the_dir_prev = parent->head_children_dirs;
			while (the_dir_prev && the_dir_prev->next) {
				if (!strcmp(the_dir_prev->next->name, newname)) {
					break;
				}
				the_dir_prev = the_dir_prev->next;
			}

			the_dir_prev->next = the_dir->next;
			the_dir->next = NULL;
		}

		/* add the directory at the end of the directories list */
		Dir *new_dir = parent->head_children_dirs;
		while (new_dir && new_dir->next) {
			new_dir = new_dir->next;
		}
		if (new_dir) {
			new_dir->next = the_dir;
		} else {
			parent->head_children_dirs = the_dir;
		}
	}
}

int main () {
	char *arg = (char*)malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
	char *op = (char*)malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
	char *op_name = (char*)malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
	Dir *home = home_malloc();
	Dir *current_dir = home;

	do
	{
		fgets(arg, MAX_INPUT_LINE_SIZE, stdin);
		if (arg[strlen(arg) - 1] == '\n') {
			arg[strlen(arg) - 1] = '\0';
		}
		sentence_breaker(arg, op, op_name);
		
		if (!strcmp(arg, "stop")) {
			stop(home);
			break;
		} else if (!strcmp(op, "touch")) {
			touch(current_dir, op_name);
		} else if (!strcmp(op, "mkdir")) {
			mkdir(current_dir, op_name);
		} else if (!strcmp(op, "ls")) {
			ls(current_dir);
		} else if (!strcmp(op, "pwd")) {
			char *pwd_output =  pwd(current_dir);
			printf("%s\n", pwd_output);
			free(pwd_output);
		} else if (!strcmp(op, "cd")) {
			cd(&current_dir, op_name);
		} else if (!strcmp(op, "rm")) {
			rm(current_dir, op_name);
		} else if (!strcmp(op, "rmdir")) {
			rmdir(current_dir, op_name);
		} else if (!strcmp(op, "tree")) {
			tree(current_dir, 0);
		} else if (!strcmp(op, "mv")) {
			char *old = (char*)malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
			char *new = (char*)malloc(sizeof(char) * MAX_INPUT_LINE_SIZE);
			sentence_breaker(op_name, old, new);

			mv(current_dir, old, new);

			free(old);
			free(new);
		}
	} while (1);

	free(arg);
	free(op);
	free(op_name);
	free(home->name);
	free(home);
	
	return 0;
}
