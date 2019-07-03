import processing.opengl.*; 
import KinectPV2.*;
import ddf.minim.*;
import blobDetection.*; 
import toxi.geom.*; 
import toxi.processing.*;
import shiffman.box2d.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.common.*; 
import org.jbox2d.dynamics.*;
import java.util.Collections; 

KinectPV2 kinect; 
BlobDetection theBlobDetection;
Minim minim;
AudioPlayer jing,yu,huang,ping,yue;
ToxiclibsSupport gfx; //toxiclibsSupport用于显示多边形
PolygonBlob poly; //声明自定义PolygonBlob对象
PImage cam, blobs;//用于保存传入图像的PImage和用于blob检测的较小图像
PImage jingjv,yujv,huangmei,pingjv,yuejv;
int kinectWidth = 640;
int kinectHeight = 480;
float reScale;
color bgColor,jianbian;
String[] palettes = {
 "-1117720,-13683658,-8410437,-9998215,14178341,-5804972,-3498634",   
 "-67879,-9633503,-8858441,-588031",   
 "-4741770,-9232823,-3195858,8989771,-2850983,-10314372" 
};
color[] colorPalette;
Box2DProcessing box2d;
ArrayList<CustomShape> polygons= new ArrayList<CustomShape>();

void setup() {
 size(1920, 1080, P3D);
 kinect = new KinectPV2(this); 
 kinect.enableBodyTrackImg(true);
 kinect.init();
 minim = new Minim(this);
 jing = minim.loadFile("jingjv.mp3");
 yu = minim.loadFile("yujv.mp3");
 huang = minim.loadFile("huangmeixi.mp3");
 ping = minim.loadFile("pingjv.mp3");
 yue = minim.loadFile("yuejv.mp3");
 reScale = (float) width / kinectWidth;
 jingjv = loadImage("jingjv1.png");
 yujv = loadImage("yujv1.png");
 huangmei = loadImage("huangmeixi1.png");
 pingjv = loadImage("pingjv1.png");
 yuejv = loadImage("yuejv1.png");
 blobs = createImage(kinectWidth/3, kinectHeight/3, RGB); 
 //将blob检测对象初始化为blob图像尺寸
 theBlobDetection = new BlobDetection(blobs.width, blobs.height); 
 theBlobDetection.setThreshold(0.2);
 gfx = new ToxiclibsSupport(this);
 //设置box2d，创建世界，设置重力
 box2d = new Box2DProcessing(this); 
 box2d.createWorld();
 box2d.setGravity(0, -10);
 setRandomColors(1); 
}
void draw() {
 background(255);
 fill(bgColor);
 cam = kinect.getBodyTrackImage();
 blobs.copy(cam, 0, 0, cam.width, cam.height, 0, 0, blobs.width,blobs.height); 
 blobs.filter(BLUR, 1); 
 theBlobDetection.computeBlobs(blobs.pixels); 
 poly = new PolygonBlob(); 
 poly.createPolygon(); 
 poly.createBody(); 
 switchOpera();
 updateAndDrawBox2D(); 
 poly.destroyBody();
 setRandomColors(200); 
}
void updateAndDrawBox2D() { 
 if (frameRate > 10) {
 polygons.add(new CustomShape(kinectWidth/2, -50, random(2.5,
20)));
 }
 box2d.step();
 translate(0, (height-kinectHeight*reScale)/2); 
 scale(reScale);
 //显示人物多边形
 noStroke();
 jianbian = lerpColor(color(0), color(100),random(0.4,0.9));
 fill(jianbian);
 gfx.polygon2D(poly);
 for (int i=polygons.size()-1; i>=0; i--) { 
 CustomShape cs = polygons.get(i); 
if (cs.done()) { 
 polygons.remove(i);
 } else { 
 cs.update();
 cs.display();
 }
 }
}
