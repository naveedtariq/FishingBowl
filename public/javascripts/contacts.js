function loadcontacts(){

	$.getJSON('/yahoo/getContacts',function(a){
		
//		$('.contacts').append("<br /><form action='/invite' method='post'>");
		
		var i=0;
		for( var key in a)
		{
			$('form.contacts').append("<input id=" + i + " name="+ i +" type='checkbox' value="+a[key]+" checked/> <label for="+ i +">"+ key +" ("+ a[key] +")</label><br />");
			i = i + 1;
		}
		
		$('form.contacts').append('<br /><input name="Invite" type="submit" value="Invite" />');		
		
	});
}
