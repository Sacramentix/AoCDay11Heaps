import h2d.Text;
import hxd.Event;
import h2d.Graphics;
import sys.io.File;
import hxd.Window;

class Day11 extends hxd.App {

    public static var instance:Day11;
    public var seatMap:Array<Array<Seat>>;
    public var seatMapGraphics:Graphics;
    public var updatePart1Button:TextButton;
    public var updatePart2Button:TextButton;
    public var resetButton:TextButton;
    public var resultButton:TextButton;
    public var resultText:Text;
    
    

    static function main() {
        instance = new Day11(); 
    }

    override function init() {   
        
        //hxd.Res.initLocal();
        engine.backgroundColor = 0xFF222831;
        //Window.getInstance().displayMode = Fullscreen;
        
        seatMapGraphics = new Graphics(this.s2d);
        var offsetX = 35;
        var offsetY = 35;
        var width = 250;
        var height = 100;
        updatePart1Button = new TextButton(width, height, "Update part 1", s2d);
        updatePart2Button = new TextButton(width, height, "Update part 2", s2d);
        resultButton = new TextButton(width, height, "Result", s2d);
        resetButton = new TextButton(width, height, "Reset", s2d);
        resultText = new Text(hxd.res.DefaultFont.get(), s2d);
        resultText.text = "result : 0";
        updatePart1Button.onClick = function (e:Event) {
            updateSeatPart1();
        };
        updatePart2Button.onClick = function (e:Event) {
            updateSeatPart2();
        };
        resultButton.onClick = function (e:Event) {
            result();
        };
        resetButton.onClick = function (e:Event) {
            reset();
        };
        reset();
        onResize();
    }

    override function update(dt:Float) {

    }

    override function onResize() {
        var offsetX = 35;
        var offsetY = 35;
        var width = 250;
        var height = 50;
        updatePart1Button.x = updatePart2Button.x  = resultButton.x = resetButton.x = resultText.x = Window.getInstance().width - 250 - offsetX;
        updatePart1Button.y = offsetY;
        updatePart2Button.y = 2*offsetY+height;
        resultButton.y = 3*offsetY+height*2;
        resetButton.y = 4*offsetY+height*3;
        resultText.y = 5*offsetY+height*4;
        resultButton.onResize(width, height);
        updatePart1Button.onResize(width, height);
        updatePart2Button.onResize(width, height);
        resetButton.onResize(width, height);
        
    }

    public function reset() {
        var input:String = sys.io.File.getContent('src/input.txt');
        var a = input.split("\r\n");
        seatMap = a.map(function (s:String):Array<Seat> {
            var smap = s.split("");
            var tileMap:Array<Seat> = [];
            for (c in smap) {
                switch c {
                    case ".":
                        tileMap.push(Seat.Floor);
                    case "L":
                        tileMap.push(Seat.Empty);
                    case "#":
                        tileMap.push(Seat.Occupied);
                }
            }
            return tileMap;
        });
        drawSeatMap();
    }

    public function result() {
        var occupied = 0;
        for (row in seatMap) {
            for (seat in row) {
                if (seat == Seat.Occupied) occupied++;
            }
        }
        resultText.text = "result : " + occupied;
    }

    public function updateSeatPart1() {
        var tempSeatMap = new Array<Array<Seat>>();
        for (y in 0...seatMap.length) {
            var row = seatMap[y];
            var futurRow = new Array<Seat>();
            tempSeatMap.push(futurRow);
            for (x in 0...row.length) {
                //trace(row.length);
                //trace(" x : " + x + " y : " + y);
                var seat = row[x];
                if (seat == Seat.Floor) {
                    futurRow.push(Seat.Floor);
                    continue;
                }
                var occupiedSeat = 0;
                for (n in (y-1)...(y+2)) {
                    if (n<0||n>=row.length) {
                        
                        continue;
                    }
                    for (m in (x-1)...(x+2)) {
                        if (m<0||n>=seatMap.length) {
                            
                            continue;
                        }
                        if (x==m && y==n) continue;
                        //var seatType = seatMap[n][m];//seatMap[n][m] != null ? seatMap[n][m] : Seat.Floor;
                        if (seatMap[n][m] == Seat.Occupied) occupiedSeat++;
                    }
                }
                if (seat == Seat.Empty && occupiedSeat == 0) futurRow.push(Seat.Occupied);
                else if (seat == Seat.Occupied && occupiedSeat >= 4) futurRow.push(Seat.Empty);
                else futurRow.push(seat);
            }
        }
        //trace(tempSeatMap);
        //trace(seatMap);
        seatMap = tempSeatMap;
        drawSeatMap();
    }

    public function updateSeatPart2() {
        var tempSeatMap = new Array<Array<Seat>>();
        for (y in 0...seatMap.length) {
            var row = seatMap[y];
            var futurRow = new Array<Seat>();
            tempSeatMap.push(futurRow);
            for (x in 0...row.length) {
                //trace(row.length);
                //trace(" x : " + x + " y : " + y);
                var seat = row[x];
                if (seat == Seat.Floor) {
                    futurRow.push(Seat.Floor);
                    continue;
                }
                var occupiedSeat = 0;
                for (n in -1...2) {
                    for (m in -1...2) {
                        if (m == 0 && n == 0) continue;
                        var findSeat = false;
                        var r = 1;
                        do {
                            var dy = y+r*n;
                            var dx = x+r*m;
                            if ( ( dy < 0 || dy >= seatMap.length ) || ( dx < 0 || dx >= row.length ) ) break;
                            var theSeat = seatMap[dy][dx];
                            if (theSeat != Seat.Floor) {
                                if (theSeat == Seat.Occupied) occupiedSeat++;
                                findSeat = true;
                            }
                            r++;
                        } while (!findSeat);

                    }
                }
                if (seat == Seat.Empty && occupiedSeat == 0) futurRow.push(Seat.Occupied);
                else if (seat == Seat.Occupied && occupiedSeat >= 5) futurRow.push(Seat.Empty);
                else futurRow.push(seat);
            }
        }
        //trace(tempSeatMap);
        //trace(seatMap);
        seatMap = tempSeatMap;
        drawSeatMap();
    }

    public function drawSeatMap() {
        var offsetX = 35;
        var offsetY = 35;
        var tileWidth = 6;
        var tileHeight = 6;
        seatMapGraphics.clear();
        var y = 0;
        for (row in seatMap) {
            var x = 0;
            for (seat in row) {
                switch seat {
                    case Seat.Floor:
                        seatMapGraphics.beginFill(0x222831);
                    case Seat.Empty:
                        seatMapGraphics.beginFill(0x505762);
                    case Seat.Occupied:
                        seatMapGraphics.beginFill(0x007a80);
                }
                seatMapGraphics.drawRect(x*tileWidth+offsetX, y*tileHeight+offsetY, tileWidth, tileHeight);
                x++;
            }
            y++;
        }
  
    }
    
}

enum abstract Seat(Int) from Int to Int {
    var Floor;
    var Empty;
    var Occupied;
}