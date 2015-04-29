var githubButton = document.getElementById("github"),
	downloadButton = document.getElementById("download"),
	downloader = document.getElementById("downloader");
downloadButton.addEventListener("click", function(){
	downloader.src = "Morph.zip";
}, false);
githubButton.addEventListener("click", function(){
	var win = window.open("https://github.com/FelisPhasma/Morph", '_blank');
	win.focus();
}, false);


// RequestAnimFrame: a browser API for getting smooth animations
window.requestAnimFrame = (function(){
  return  window.requestAnimationFrame       || 
		  window.webkitRequestAnimationFrame || 
		  window.mozRequestAnimationFrame    || 
		  window.oRequestAnimationFrame      || 
		  window.msRequestAnimationFrame     ||  
		  function(callback){
			window.setTimeout(callback, 1000 / 60);
		  };
})();
var canvas = document.getElementById("c"),
	ctx = canvas.getContext("2d"),
	W,
	H,
	dotCount = 100,
	dots = [],
	minDist = 90;
function resize(){
	W = canvas.width = window.innerWidth; 
	H = canvas.height = window.innerHeight;
};
window.addEventListener("resize", resize, false);
function dot() {
	this.x = Math.random() * W;
	this.vx = -1 + Math.random() * 2;
	this.y = Math.random() * H;
	this.vy = -1 + Math.random() * 2;
	this.radius = 5;
	this.r = 55 + Math.round(Math.random() * 200);
	this.g = 55 + Math.round(Math.random() * 200);
	this.b = 55 + Math.round(Math.random() * 200);
	this.rgba = "rgba(" + this.r + ", " + this.g + ", " + this.b + ", 1)";
	this.draw = function() {
		ctx.fillStyle = this.rgba;
		ctx.beginPath();
		ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2, false);
		ctx.fill();
	};
};
function draw() {
	ctx.fillStyle = "rgba(0,0,0,1)";
	ctx.fillRect(0,0,W,H);
	update();
	for (i = 0; i < dotCount; i++)
		dots[i].draw();
};
function update() {
	for (i = 0; i < dotCount; i++) {
		var d = dots[i];
		d.x += d.vx;
		d.y += d.vy;
		if(d.x + d.radius > W) 
			d.x = d.radius;
		else if(d.x - d.radius < 0)
			d.x = W - d.radius;
		if(d.y + d.radius > H) 
			d.y = d.radius;
		else if(d.y - d.radius < 0)
			d.y = H - d.radius;
		for(var j = i + 1; j < dotCount; j++)
			distance(d, dots[j])
	};
};
function distance(d1, d2) {
	var dx = d1.x - d2.x,
		dy = d1.y - d2.y,
		dist = Math.sqrt(dx*dx + dy*dy);
	if(dist <= minDist) {
		ctx.beginPath();
		ctx.strokeStyle = "rgba(255, 255, 255, "+ (1 - dist/minDist) +")";
		ctx.moveTo(d1.x, d1.y);
		ctx.lineTo(d2.x, d2.y);
		ctx.stroke();
		
		var ax = dx/8000,
			ay = dy/8000;
		d1.vx -= ax;
		d1.vy -= ay;
		d2.vx += ax;
		d2.vy += ay;
	};
};
function animloop() {
	requestAnimFrame(animloop);
	draw();
};
function init(){
	resize();
	for(i = 0; i < dotCount; i++)
		dots.push(new dot());
	animloop();
};
init();