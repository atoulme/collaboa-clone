function toggle(id) {
  if (document.getElementById(id).style.display == 'none') {
    document.getElementById(id).style.display = 'block'
  } else {
    document.getElementById(id).style.display = 'none'
  }
}

function toggleChanges() {
  if (document.getElementById("changes").style.display == "none") {
    document.getElementById("changes").style.display  = "block";
    document.getElementById("revision").style.display = "none";
    document.getElementById("show_changes").style.display  = "none";
    document.getElementById("hide_changes").style.display = "inline";
  } else {
    document.getElementById("changes").style.display  = "none";
    document.getElementById("revision").style.display = "block";
    document.getElementById("show_changes").style.display  = "inline";
    document.getElementById("hide_changes").style.display = "none";
  }
}

function toggleInputSize(id) {
  if (document.getElementById(id).className == "smalltextarea") {
    document.getElementById(id).className = "largetextarea";
    document.getElementById('toggleinputsize').innerHTML 
                        = '<a href="javascript:toggleInputSize(\''+id+'\')">mindre textfält</a>';
  } else {
    document.getElementById(id).className = "smalltextarea";
    document.getElementById('toggleinputsize').innerHTML 
                        = '<a href="javascript:toggleInputSize(\''+id+'\')">större textfält</a>';
  }
}

function switch_category(selectobj)
{
	var category_id = selectobj.options[selectobj.selectedIndex].value;
	var url = new String(window.location);
	cleanurl = url.replace(/\?\w+=\d+/, "");
	cleanurl = cleanurl.replace(/\d+$/, "");

	if(category_id != "") {
	  // check for slash at end
	  lastchar = cleanurl.substr(cleanurl.length - 1);
	  if (lastchar != "/") {
	    loc = cleanurl + '/' + category_id;
	  } else {
	    loc = cleanurl + category_id; 
	  }
	} else {
	  loc = cleanurl;
	}
	window.location = loc;
}
