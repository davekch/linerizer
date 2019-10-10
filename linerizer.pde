PImage input;
PImage output;
int width, height;
int pixelsize = 5;

void setup(){
    size(50, 50);
    surface.setResizable(true);
    input = loadImage("test.jpg");
    width = 150;
    input.resize(width, 0);
    height = input.height;
    surface.setSize(width*pixelsize, height*pixelsize);
    input.filter(GRAY);
    output = errorDiffusion(input, 80);
}

void draw(){
    displayPixels(output, pixelsize);
}


void displayPixels(PImage image, int pixelwidth){
    noStroke();
    for(int y=0; y<image.height; y++){
        for(int x=0; x<image.width; x++){
            int loc = x + y * image.width;
            fill(image.pixels[loc]);
            rect(x*pixelwidth, y*pixelwidth, pixelwidth, pixelwidth);
        }
    }
}

PImage errorDiffusion(PImage in, int threshold){
    PImage out = createImage(in.width, in.height, RGB);
    in.loadPixels();
    out.loadPixels();
    float err = 0;
    float tmp;
    for(int i=0; i<in.width*in.height; ++i){
        tmp = brightness(in.pixels[i]) + err;
        if(tmp > threshold){
            out.pixels[i] = color(255);
            err = brightness(in.pixels[i]) - 255;
        } else {
            out.pixels[i] = color(0);
            err = 255 - brightness(in.pixels[i]);
        }
    }
    return out;
}
