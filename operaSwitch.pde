String[] a = {"jingjv","yujv","huangmei","yuejv","pingjv"};

float startX ;
float stopX ;
float startY ;
float stopY;
float x = startX;
float y = startY;
float step = 0.5;
float pct = 0.0;

int i = 0;
int n = 0;
int a1,a2;
int a11,a22;
int NONE = -1;
int PLAY = 0;
enum STEP{ NONE,PLAY,STOP,NUM};
STEP cstep      = STEP.STOP;
STEP next_step  = STEP.NONE;

void switchOpera()
{
  if(pct < 1.0){
    pct += step;
  }
    
    switch(i){
     case 1:
     image(jingjv,xx,yy,889,703);
     yue.pause();
     jing.play();
     break;
      
      case 2:
       image(yujv,xx,yy);
       jing.pause();
       yu.play();
      break;
       
      case 3:
       image(huangmei,xx,yy,889,703);
       yu.pause();
       huang.play();
      break;
      
      case 4:
      image(pingjv,xx,yy,889,703);
      huang.pause();
      ping.play();
      break;
      
      case 5:
      image(yuejv,xx,yy,889,703);
      ping.pause();
      yue.play();
      break;
    }
    if(zz == true){
   a1=1;
    }else{a1=0;}
    if(zz == false){
    a2=1;
    }else{a2=0;}
    switch(cstep){
      case STOP:
      {int e;
      e = a1+a2;
      a11 = a1;
      a22 = a2;
      if(e>0){
        next_step = STEP.PLAY;}}
      break;
      case PLAY:
     {if(a11!=a1||a22!=a2){
       next_step = STEP.STOP;
     }}
      break;
      }
      if(next_step!=STEP.NONE){
      switch(next_step)
      {
        case PLAY:
        {if(a1==1)
        {
          i=i+1;
          pct = 0;
          if(i>a.length){
            i=0;
            pct = 0;
          }
        }
        if(a2==1){
         i=i+0;
        }
      }
      break;
      case STOP:{}
      break;
      }
      cstep=next_step;
      next_step=STEP.NONE;
      }
  }
