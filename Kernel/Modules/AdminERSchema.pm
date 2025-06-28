package Kernel::Modules::AdminERSchema;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}


sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LogObject    = $Kernel::OM->Get('Kernel::System::Log');

	my $Diagram = $ParamObject->GetParam( Param => 'Diagram' ) || 'schema.svg';
	my $Home    = $Kernel::OM->Get('Kernel::Config')->Get('Home');

	$Param{Diagram} = $Diagram;
	$Param{WebPath} = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::WebPath');


    # ------------------------------------------------------------ #
    # Regenerate
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Regenerate' ) {

		my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
		my $MYSQL_PASSWORD = $ConfigObject->Get('DatabasePw');
		my $DumpCMD = "mysqldump -h db -u otobo -p$MYSQL_PASSWORD otobo --no-data > $Home/var/tmp/dump.sql";

		system($DumpCMD);

		$Self->_MakeSchema();
		$Self->_MakeSchema( RankDir => 'LR' );
		$Self->_MakeSchema( Type => 'neato');
		$Self->_MakeSchema( Type => 'twopi');
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

	if( ! -e "$Home/var/tmp/dump.sql" ) {

        $LayoutObject->Block(
            Name => 'NoSchemaDump',
            Data => \%Param,
        );		
	}
	else {
        $LayoutObject->Block(
            Name => 'OverviewResult',
            Data => \%Param,
        );		
	}


    $Param{Selection} = $LayoutObject->BuildSelection(
        Data       => {
			'schema.svg' => 'default',
			'schema_LR.svg' =>'default LR',
			'schema_neato.svg' => 'neato',
			'schema_twopi.svg' => 'twopi',


			# 'default' => 'schema.svg',
			# 'default LR' => 'schema_LR.svg',
			# 'neato' => 'schema_neato.svg',
			# 'twopi' => 'twopi.svg',
		},
        Name          => 'Diagram',
        Class         => 'Modernize',
        SelectedID    => $Diagram,
    );

	my $Output = $LayoutObject->Header();
	$Output .= $LayoutObject->NavigationBar();

	$Output .= $LayoutObject->Output(
		TemplateFile => 'AdminERSchema',
		Data         => \%Param,
	);
	$Output .= $LayoutObject->Footer();
	return $Output;
}

sub _MakeSchema {

    my ( $Self, %Param ) = @_;

	my $Type    = $Param{Type} // '';
	my $RankDir = $Param{RankDir} // '';
	my $Name    = "schema";
	my $Home    = $Kernel::OM->Get('Kernel::Config')->Get('Home');

	if($Type) {
		$Name .= "_$Type";
		$Type = "-l $Type";		
	}

	if($RankDir) {
		$Name .="_$RankDir";
		$RankDir = "--graphattr \"rankdir=$RankDir\"";
	}

	my $CMD = "sqlt-graph --show-datatypes -d MySQL $Type $RankDir -t svg -o $Home/var/httpd/htdocs/common/img/$Name.svg $Home/var/tmp/dump.sql";

	system($CMD);

	return;
}


1;
