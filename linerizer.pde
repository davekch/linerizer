PImage input;
int width, height;

void setup(){
    size(50, 50);
    surface.setResizable(true);
    input = loadImage("test.jpg");
    width = 800;
    input.resize(width, 0);
    height = input.height;
    surface.setSize(width, height);
}

void draw(){
    image(input, 0, 0);
}
