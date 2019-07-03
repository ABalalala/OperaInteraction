class CustomShape { 
 Body body; 
 Polygon2D toxiPoly; 
 color col; 
 float r;
 CustomShape(float x, float y, float r) {
 this.r = r; 
 makeBody(x, y); 
 }
 void makeBody(float x, float y) {
//在box2d世界坐标中定义一个位于xy的动态体，创建它并设置此box2d体的速度和角度的初始值
 BodyDef bd = new BodyDef();
 bd.type = BodyType.DYNAMIC;
 bd.position.set(box2d.coordPixelsToWorld(new Vec2(x, y)));
 body = box2d.createBody(bd);
 body.setLinearVelocity(new Vec2(random(-5, 5), random(2, 6)));
 body.setAngularVelocity(random(-5, 5));
 if (r == -1) { 
 PolygonShape sd = new PolygonShape(); 
 toxiPoly = new Circle(random(5, 15)).toPolygon2D(int(random(3,3)));
 Vec2[] vertices = new Vec2[toxiPoly.getNumPoints()];
 for (int i=0; i<vertices.length; i++) {
 Vec2D v = toxiPoly.vertices.get(i);
 vertices[i] = box2d.vectorPixelsToWorld(new Vec2(v.x, v.y));
 }
 //将顶点放入box2d形状
 sd.set(vertices, vertices.length); 
 body.createFixture(sd, 1); 
 } else {
 CircleShape cs = new CircleShape(); 
 cs.m_radius = box2d.scalarPixelsToWorld(r);
 FixtureDef fd = new FixtureDef();
 fd.shape = cs;
 fd.density = 1;
 fd.friction = 0.01;
 fd.restitution = 0.3;
 body.createFixture(fd); 
 }
 }
 void update() {
 Vec2 posScreen = box2d.getBodyPixelCoord(body);
 Vec2D toxiScreen = new Vec2D(posScreen.x, posScreen.y);
 boolean inBody = poly.containsPoint(toxiScreen);
//如果形状在人体内
 if (inBody) {
 Vec2D closestPoint = toxiScreen;
 float closestDistance = 9999999;
 for (Vec2D v : poly.vertices) {
 float distance = v.distanceTo(toxiScreen);
 if (distance < closestDistance) {
 closestDistance = distance;
 closestPoint = v;
 }
 }
 Vec2 contourPos = new Vec2(closestPoint.x, closestPoint.y);
 Vec2 posWorld = box2d.coordPixelsToWorld(contourPos); 
 float angle = body.getAngle(); 
 body.setTransform(posWorld, angle);
 }
 } 
 void display() {
 Vec2 pos = box2d.getBodyPixelCoord(body);
 pushMatrix();
 translate(pos.x, pos.y);
 noStroke(); 
 fill(bgColor); 
 if (r == -1) { 
 float a = body.getAngle();
 rotate(-a); 
 gfx.polygon2D(toxiPoly);
 } else {
 ellipse(0, 0, r*2, r*2);
 }
 popMatrix();
 } 
 boolean done() {
 Vec2 posScreen = box2d.getBodyPixelCoord(body);
 boolean offscreen = posScreen.y > height;
 if (offscreen) {
 box2d.destroyBody(body);
 return true;
 }
 return false;
 }
}
void setRandomColors(int nthFrame){
  fill(0);
//  text(frameCount,-20,0); 
   if (frameCount % nthFrame == 0) {     
     String[] paletteStrings = split(palettes[int(random(palettes.length))], ",");
     colorPalette = new color[paletteStrings.length];
      for (int i=0; i<paletteStrings.length; i++) {       
      colorPalette[i] = int(paletteStrings[i]);     
    }
     bgColor = colorPalette[0];     
     
 }
} 
