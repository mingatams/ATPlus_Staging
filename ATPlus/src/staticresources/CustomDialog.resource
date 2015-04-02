/* 
 Custom Dialog box 
 Publication Date : July, 12, 2007
 Author : Haissam Abdul Malak
*/

var	divWidth = '';
var	divHeight = '';
var txtFirstButton = 'OK';
var txtSecondButton = 'Cancel'
		function DisplayConfirmMessage(msg,width,height)
		{
				// Set default dialogbox width if null
				if(width == null)
				divWidth = 180 
				else 
				divWidth = width;
				
				// Set default dialogBox height if null
				if(height == null)
				divHeight = 90 
				else 
				divHeight = height;
				
	
				// Ge the dialogbox object
				var divLayer = document.getElementById('divConfMessage');
				// Set dialogbox height and width
				SetHeightWidth(divLayer)
				// Set dialogbox top and left
				SetTopLeft(divLayer);
		
				// Show the div layer
				divLayer.style.display = 'block';
				// Change the location and reset the width and height if window is resized
				window.onresize = function() { if(divLayer.style.display == 'block'){ SetTopLeft(divLayer); SetHeightWidth(divLayer)}}
				// Set the dialogbox display message
				document.getElementById('confirmText').innerText = msg;
		}
		
		function SetTopLeft(divLayer)
		{
			// Get the dialogbox height
			var divHeightPer = divLayer.style.height.split('px')[0];
			
			 // Set the top variable 
			var top = (parseInt(document.body.offsetHeight)/ 2) - (divHeightPer/2)
			// Get the dialog box width
			var divWidthPix = divLayer.style.width.split('px')[0];
			
		    // Get the left variable
		    var left = (parseInt(document.body.offsetWidth)/2) - (parseInt(divWidthPix)/2);
			// set the dialogbox position to abosulute
		    divLayer.style.position = 'absolute';
		
		    // Set the div top to the height 
		    divLayer.style.top = top

		    // Set the div Left to the height 
		    divLayer.style.left = left;
		}
		function SetHeightWidth(divLayer)
		{
			// Set the dialogbox width
			divLayer.style.width = divWidth + 'px';
			// Set the dialogbox Height
			divLayer.style.height = divHeight + 'px'
		}
		function SetText(txtButton1,txtButton2)
		{
				// Set display text for the two buttons
				if(txtButton1 == null)
				document.getElementById('btnConfOK').innerText = txtFirstButton;
				else
				document.getElementById('btnConfOK').innerText = txtButton1;
				
								// Set display text for the two buttons
				if(txtButton2 == null)
				document.getElementById('btnConfCancel').innerText = txtSecondButton;
				else
				document.getElementById('btnConfCancel').innerText = txtButton2;

		}
		function SetDefaultButton(defaultButton)
		{
				// Set the focus on the Cancel button
				document.getElementById(defaultButton).focus();
		}