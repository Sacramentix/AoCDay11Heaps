import h2d.Interactive;
import h2d.Tile;
import h2d.Text;
import hxd.Event;
import h2d.Object;
import h2d.RenderContext;

class TextButton extends Interactive {

    public var label:Text;

    private var normal:Tile;
    private var hover:Tile;
    private var press:Tile;
    
    private var pressed:Bool;
  
    public function new(w:Float = 250, h:Float = 100, text:String, ?parent:Object) {

        super(w, h, parent);
        label = new Text(hxd.res.DefaultFont.get(), this);
        label.textAlign = Align.Center;
        label.text = text;
        label.x = 0;
        label.color.setColor(0xffffffff);
        
        normal = Tile.fromColor(0xa5a5a5);
        hover = Tile.fromColor(0xb5b5b5);
        press = Tile.fromColor(0xc5c5c5);
        
    }

    public function onResize(w:Float, h:Float) {
        normal.scaleToSize(w, h);
        hover.scaleToSize(w, h);
        press.scaleToSize(w, h);
        label.maxWidth = w;
        label.y = (h - label.textHeight) / 2;
        width = w;
        height = h;

    }


    public override function draw(ctx:RenderContext) {
        if (pressed) {
            emitTile(ctx, press);
        } else {
            emitTile(ctx, isOver() ? hover : normal);
        }
    }

    override public function handleEvent(e:Event) {
        if (e.kind == EventKind.EPush) {
          pressed = true;
        } else if (e.kind == EventKind.ERelease || e.kind == EventKind.EReleaseOutside) {
          pressed = false;
        }
        super.handleEvent(e);
    }
}