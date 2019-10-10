PImage input;
PImage output;
int width, height;
int pixelsize = 3;
ArrayList<Point> path;

void setup () {
    size(50, 50);
    surface.setResizable(true);
    input = loadImage("test.jpg");
    width = 300;
    input.resize(width, 0);
    height = input.height;
    surface.setSize(width*pixelsize, height*pixelsize);
    input.filter(GRAY);
    output = errorDiffusion(input, 60);
    path = neighborPathFromImage(output);
}

void draw () {
    drawPath(path, pixelsize);
}


void displayPixels (PImage image, int pixelwidth) {
    noStroke();
    for (int y=0; y<image.height; y++) {
        for (int x=0; x<image.width; x++) {
            int loc = x + y * image.width;
            fill(image.pixels[loc]);
            rect(x*pixelwidth, y*pixelwidth, pixelwidth, pixelwidth);
        }
    }
}

void drawPath (ArrayList<Point> points, float scale) {
    stroke(0);
    for (int i=0; i<points.size()-1; i++) {
        Point from = points.get(i);
        Point to = points.get(i+1);
        line(from.x*scale, from.y*scale, to.x*scale, to.y*scale);
    }
}

PImage errorDiffusion (PImage in, int threshold) {
    PImage out = createImage(in.width, in.height, RGB);
    in.loadPixels();
    out.loadPixels();
    float err = 0;
    float tmp;
    for (int i=0; i<in.width*in.height; ++i) {
        tmp = brightness(in.pixels[i]) + err;
        if (tmp > threshold) {
            out.pixels[i] = color(255);
            err = brightness(in.pixels[i]) - 255;
        } else {
            out.pixels[i] = color(0);
            err = 255 - brightness(in.pixels[i]);
        }
    }
    return out;
}

ArrayList<Point> neighborPathFromImage (PImage img) {
    // get all black points
    ArrayList<Point> points = new ArrayList<Point>();
    for (int y=0; y<img.height; y++) {
        for (int x=0; x<img.width; x++) {
            if (brightness(img.pixels[x + y*img.width]) == 0) {
                points.add(new Point(x, y));
            }
        }
    }
    // construct path through nearest neighbors
    return closestNeighborPath(points);
}

ArrayList<Point> closestNeighborPath (ArrayList<Point> pointList) {
    // returns the list of points folling the nearest neighbor
    // using linear search
    ArrayList<Point> path = new ArrayList<Point>();
    Point current = pointList.get(0);
    pointList.remove(0);
    while (pointList.size() > 0) {
        int min = current.square_distance(pointList.get(0));
        int neighborIndex = 0;
        for (int i=0; i<pointList.size()-1; i++) {
            int dist = current.square_distance(pointList.get(i));
            if (dist < min) {
                min = dist;
                neighborIndex = i;
            }
        }
        Point neighbor = pointList.get(neighborIndex);
        pointList.remove(neighborIndex);
        path.add(neighbor);
        current = neighbor;
    }
    return path;
}

class Point {
    int x, y;

    Point (int x, int y) {
        this.x = x;
        this.y = y;
    }

    int square_distance (Point p) {
        return (x - p.x)*(x - p.x) + (y - p.y)*(y - p.y);
    }
}
