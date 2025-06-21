window.ERSchema = (function (TargetNS) {

	TargetNS.Init = function () {

		$('#schema').each(function(Idx,Schema){

			Schema.panzoom = Panzoom(Schema, {
				maxScale: 40
			});
			Schema.panzoom.pan(10, 10);
			Schema.panzoom.zoom( 1, { animate: true, canvas: true });

			Schema.parentElement.addEventListener('wheel', Schema.panzoom.zoomWithWheel);

		});

		let Diagram = $('#schema').attr('diagram');
		$('#Diagram').val( Diagram );

		$('#Diagram').on('change', function(e){
				
			$('#DiagramForm').submit();
		});

		$('#RegenerateForm').on('submit',function(e) {

			$('#loader').css('display','block');
		});
	};

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;

}(window.ERSchema||{}));

