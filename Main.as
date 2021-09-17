package  {
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.utils.*;
	
	public class Main extends MovieClip{
		
		private var img:BitmapData;
		private var bmp:Bitmap;
		private var bd:BitmapData;
		
		var radius:Number = 150;
		var y_radius:int = 100;
		var startAngle:Number = 356;
		var numWalls:int = 0;
		var counter:int = 0;
		var shrink:Number = 0;
		var dir = 0;
		
		public function Main() {
			img = new IMG();
			bd = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			bmp = new Bitmap(bd);
			stage.addChild(bmp);
				
			
			//top left
			//p1 = new Point(cx - 20, cy - 30);
			//top right
			//p2 = new Point(cx + 50, cy  - 80);
			//bottom left
			//p3 = new Point(cx - 50, cy + 50);
			//bottom right
			//p4 = new Point(cx + 50, cy + 10);
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			//setInterval(update, 1000);
			
			
			
		}
		
		function createWall(currAngle:Number, wallNum:int):Object
		{
			if(currAngle > 360)
			{
				currAngle -= 360;
			}
			
			var p1:Point;
			var p2:Point;
			var p3:Point;
			var p4:Point;
			
			var cx:Number = stage.stageWidth/2;
			var cy:Number = stage.stageHeight/2;
			
			var angleRad:Number = (currAngle -45) * Math.PI / 180;
			
			//bottom right
			p4 = new Point( Math.cos(angleRad) * radius + cx  ,  Math.sin(angleRad) * y_radius + cy  );
			
			angleRad = (currAngle + 45) * Math.PI / 180;
	
			//bottom left
			p3 = new Point(cx + Math.cos(angleRad) * radius ,  Math.sin(angleRad) * y_radius + cy);
			
			//and now the suppliment
			//top right
			//startAngle += 90;
			//angleRad = startAngle * Math.PI / 180;
			//p2 = new Point(cx + Math.cos(angleRad) * radius , cy + Math.sin(angleRad) * radius);
			p2 = new Point(p4.x, p4.y - y_radius);
			
			//top left
			//startAngle += 90;
			//angleRad = startAngle * Math.PI / 180;
			//p1 = new Point(cx + Math.cos(angleRad) * radius , cy + Math.sin(angleRad) * radius);
			//p1 = new Point(cx + Math.cos(angleRad) * radius , cy + Math.sin(angleRad) * radius);
			p1 = new Point(p3.x, p3.y - y_radius);
			
			
			
			var reportAngle:int = currAngle;
			if(numWalls > 5 && numWalls < 10)
			{
				if(dir == 0)
				{
					if(shrink < y_radius * 3)
					{
						shrink += 1;
					}
					else
					{
						dir = 1;
					}
				}
				else
				{
					if(shrink > -50)
					{
						shrink -= 1;
					}
					else
					{
						dir = 0;
					}
				}
				
				
				p2.x =  cx;
				p1.x =  cx;
				p2.y =  cy - y_radius + shrink;
				p1.y =  cy - y_radius + shrink;
				
				//reportAngle = currAngle + 45;
				//if(reportAngle > 360)
				//{
				//	reportAngle -= 360;
				//}
				
				
			}
			

			

			return { p1 : p1, p2: p2, p3: p3, p4:p4 , angle: reportAngle , wallNum:wallNum}
		}
		
		
		
		
		function update(e:Event = null):void
		{
			bd.fillRect(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 0x000000);
			var arr:Array = [];
			
			arr.push( createWall(startAngle, 1));	
			
			/**/
			if(numWalls > 2)
			{
				arr.push( createWall(startAngle + 90,2));	
			}
			
			if(numWalls > 3)
			{
				arr.push( createWall(startAngle + 180,3));
			}
			
			if(numWalls > 4)
			{
				arr.push( createWall(startAngle + 270,4) );	
			}
			
			
			arr.sortOn("angle", Array.NUMERIC | Array.DESCENDING);
			
			for(var i:int = 0; i < arr.length; i++)
			{
				//trace(arr[i].wallNum, arr[i].angle);
				drawImage(arr[i]);
			}
			
			startAngle++;
			
			if(startAngle > 360)
			{
				startAngle -= 360;
			}
			
			if(counter % 200 == 0)
			{
				numWalls++;
			}
			counter++;
			
			//trace(startAngle);
			//stage.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		function drawImage(o:Object):void
		{
			var p1:Point = o.p1;
			var p2:Point = o.p2;
			var p3:Point = o.p3;
			var p4:Point = o.p4;
			
			var leftLen:int = getDistance(p1, p3);
			var rightLen:int = getDistance(p2, p4);
			
			var startRowsAngle:Number;
			var startRowsLen:Number;
			var fromPStart:Point;
			var fromPEnd:Point;
			
			var endRowsAngle:Number;
			var endRowsLen:Number;
			var toPStart:Point;
			var toPEnd:Point;
			
			if(leftLen > rightLen)
			{
				
				startRowsLen = Number(leftLen);
				endRowsLen = Number(rightLen);
				fromPStart = p1;
				fromPEnd = p3;
				toPStart = p2;
				toPEnd = p4;
			}
			else
			{
				startRowsLen = Number(rightLen);
				endRowsLen = Number(leftLen);
				fromPStart = p2;
				fromPEnd = p4;
				toPStart = p1;
				toPEnd = p3;
				
			}
			
			startRowsAngle = getAngle(fromPStart, fromPEnd);
			endRowsAngle   = getAngle(toPStart, toPEnd);
			
			var startRowCos:Number = -1;
			var startRowSin:Number = -1;
			
			var endRowCos:Number = -1;
			var endRowSin:Number = -1;
			
			for(var row:Number = fromPStart.y; row < fromPStart.y + startRowsLen; row++)
			{
				//the percentage along the start slope
				var rowPer:Number = (row - fromPStart.y) / startRowsLen;
				
				if(startRowCos == -1)
				{
					startRowCos = Math.cos(startRowsAngle);
					startRowSin = Math.sin(startRowsAngle);
				}
				
				//these are the x and y values of the current pixel on the start slope
				var currStartX:int = (startRowCos * startRowsLen) * rowPer;
				var currStartY:int = (startRowSin * startRowsLen) * rowPer;
				//add the offset of the start pixel
				currStartX += fromPStart.x;
				currStartY += fromPStart.y;
				
				//find the corresponding pixel on the end row
				
				
				//bd.setPixel(currStartX,currStartY, 0x009900); 
				if(endRowCos == -1)
				{
					endRowCos = Math.cos(endRowsAngle) ;
					endRowSin = Math.sin(endRowsAngle);
				}
				
				var currEndX:Number = (endRowCos* endRowsLen) * rowPer;
				var currEndY:Number = (endRowSin * endRowsLen) * rowPer;
				//add the offset of the start pixel
				currEndX += toPStart.x;
				currEndY += toPStart.y;
				
				var cp1:Point = new Point(currStartX, currStartY);
				var cp2:Point = new Point(currEndX, currEndY);
				
				var slopeStartToEndAngle:Number = getAngle(cp1, cp2);
				var distanceBetweenCurrs:int = getDistance(cp1, cp2);
				
				var COS:Number = -1;
				var SIN:Number = -1;
				
				for(var col:Number = cp1.x; col < cp1.x + distanceBetweenCurrs; col++)
				{
					var colPer:Number = (col - cp1.x) / distanceBetweenCurrs;
					
					if(COS == -1)
					{
						COS = Math.cos(slopeStartToEndAngle);
						SIN = Math.sin(slopeStartToEndAngle);
					}
					
					var currColX:int = (COS * distanceBetweenCurrs) * colPer;
					var currColY:int = (SIN * distanceBetweenCurrs) * colPer;
					currColX += cp1.x;
					currColY += cp1.y;
					
					
					var xInImg:int = img.width * colPer;
					var yInImg:int = img.height * rowPer;
					var pixel:uint = img.getPixel(xInImg, yInImg);
					
					bd.setPixel(currColX,currColY, pixel); 
					
				}

			}
		}
		
		function getAngle(from:Point, to:Point):Number
		{
			var angle:Number = Math.atan2(to.y - from.y, to.x - from.x);
			return angle;
		}
		
		function getDistance(p1:Point, p2:Point):int
		{
			var dX:Number = p1.x - p2.x;
			var dY:Number = p1.y - p2.y;
			var dist:Number = Math.sqrt(dX * dX + dY * dY);
			return dist;
		}

	}
	
}
