#define P(x) ((quad*)(x))
#define C(x) ((char*)(x))
#define Q(x) ((quad)(x))
#define B(x) ((char)(x))

#define ADDRESS		0
#define SPECIAL		1
// Special values
  #define FALSE		1
  #define TRUE		9
  #define NIL		17
  #define VOID		33
  #define UNKN		65
  #define FRAH		129
#define STRING		2
#define TABLE		3
#define OBJECT		4
// Object values
  #define O_CLO		0
  #define O_FILE	1
#define STACK		5
#define DOUBLE		6
#define FUNCTION	7

typedef long long quad;

typedef struct Vals {
  quad *mem_base;
  quad *mem_ptr;
} vals;
