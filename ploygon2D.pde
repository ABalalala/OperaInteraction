//一个扩展的多边形类，与之前的PolygonBlob类非常相似（但是扩展了Toxiclibs的Polygon2D类）
//主要区别在于这个能够从它自己的形状创建（并销毁）box2d体
float xx,yy;
boolean zz;
class PolygonBlob extends Polygon2D {
 Body body; 
 void createPolygon() {
 ArrayList<ArrayList> contours = new ArrayList<ArrayList>();
 int selectedContour = 0;
 int selectedPoint = 0;
 //从blob创建轮廓
 for (int n=0; n<theBlobDetection.getBlobNb(); n++) { 
 Blob b = theBlobDetection.getBlob(n);
 if (b != null && b.getEdgeNb() > 100) {
 ArrayList<PVector> contour = new
ArrayList<PVector>();
 for (int m=0; m<b.getEdgeNb(); m++) {
 EdgeVertex eA = b.getEdgeVertexA(m);
 EdgeVertex eB = b.getEdgeVertexB(m);
 if (eA != null && eB != null) { 
   EdgeVertex fn = b.getEdgeVertexA((m+1) % b.getEdgeNb());
 EdgeVertex fp = b.getEdgeVertexA((max(0, m-1)));
 float dn = dist(eA.x*kinectWidth, eA.y*kinectHeight,
fn.x*kinectWidth, fn.y*kinectHeight);
 float dp = dist(eA.x*kinectWidth, eA.y*kinectHeight,
fp.x*kinectWidth, fp.y*kinectHeight);
 if (dn > 15 || dp > 15) {
 if (contour.size() > 0) {
 contour.add(new PVector(eB.x*kinectWidth,
eB.y*kinectHeight));
 contours.add(contour);
 contour = new ArrayList();
 } else {
 contour.add(new PVector(eA.x*kinectWidth,
eA.y*kinectHeight));
 }
 } else {
 contour.add(new PVector(eA.x*kinectWidth,
eA.y*kinectHeight));
 }
 }
 }
 }
 }
 while (contours.size() > 0) {
   //找到下一个轮廓
 float distance = 999999999; 
 if (getNumPoints() > 0) {
 Vec2D vecLastPoint = vertices.get(getNumPoints()-1);
 PVector lastPoint = new PVector(vecLastPoint.x,
vecLastPoint.y);
 for (int i=0; i<contours.size(); i++) {
 ArrayList<PVector> c = contours.get(i); //ArrayList c =
contours.get(i);
 PVector fp = c.get(0);
 PVector lp = c.get(c.size()-1);
 if (fp.dist(lastPoint) < distance) {
 distance = fp.dist(lastPoint);
 selectedContour = i;
 selectedPoint = 0;
 }
 if (lp.dist(lastPoint) < distance) {
 distance = lp.dist(lastPoint);
 selectedContour = i;
 selectedPoint = 1;
 }
 }
 } else {
 PVector closestPoint = new PVector(width, height);
 for (int i=0; i<contours.size(); i++) {
   //将轮廓添加到多边形
 ArrayList<PVector> c = contours.get(i); //ArrayList c =
contours.get(i);
 PVector fp = c.get(0);
 PVector lp = c.get(c.size()-1);
 if (fp.y > kinectHeight-5 && fp.x < closestPoint.x) {
 closestPoint = fp;
 selectedContour = i;
 selectedPoint = 0;
 }
 if (lp.y > kinectHeight-5 && lp.x < closestPoint.y) { 
   closestPoint = lp;
 selectedContour = i;
 selectedPoint = 1;
 }
 }
 }
 ArrayList<PVector> contour = contours.get(selectedContour);
// add contour to polygon
 if (selectedPoint > 0) {
 Collections.reverse(contour);
 }
 for (PVector p : contour) {
 add(new Vec2D(p.x, p.y));
 }
 contours.remove(selectedContour);
 }
 }
 void createBody() { 
 BodyDef bd = new BodyDef(); 
 body = box2d.createBody(bd);
 //如果有超过0分（屏幕上也是一个人）
 if (getNumPoints() > 0) {
   zz = true;
 Vec2[] verts = new Vec2[getNumPoints()/4]; 
 for (int i=0; i<getNumPoints()/4; i++) {
 Vec2D v = vertices.get(i*4); 
 verts[i] = box2d.coordPixelsToWorld(v.x, v.y); 
 switchOpera();
 }
 xx = 500;
 yy = 200;
 ChainShape chain = new ChainShape(); 
 chain.createChain(verts, verts.length);
 body.createFixture(chain, 1);
 }else{zz = false;}
 }
 //销毁box2d的身体
 void destroyBody() { 
 box2d.destroyBody(body);
 }
}
