{ DEFINE BASEFORM_SUPPORT}
{ DEFINE XXVIEW_FORMS}
{ DEFINE PERIODIC_FORMS}
{ DEFINE DEBUG_FORMS}
{ DEFINE DFM_LOADER}

{ DEFINE BASEDATAMODULE_SUPPORT}
{ DEFINE SERVICEBROKER_SUPPORT}

{ DEFINE SDAC_SUPPORT}
{ DEFINE SERVER_UPDATE_NOTIFICATIONS}
{ DEFINE CLDS_SUPPORT }

{ DEFINE DATETIMEOFFSET_SUPPORT}

{ DEFINE FASTSCRIPT_RTTI}
{ DEFINE DATAHANDLER}


{$DEFINE UNZIP}
{$DEFINE UNRAR}


// {$DEFINE DBF_WITH_HALCYON}
{ DEFINE DBF_WITH_UNIDAC}


{ DEFINE FR3_READONLY}


{ DEFINE REPORT_USELOG} //-- ��� ����������� �������
{ DEFINE REPORT_REFERENCES} // -- ��� ������������� ������������
{ DEFINE REPORT_CONNECTION}
{ DEFINE REPORT_FROMEDIT}



{$IFDEF VER220}
  {$DEFINE DELPHIXE}
{$ENDIF}

{$IFDEF VER230}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
{$ENDIF}

{$IFDEF VER240}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
{$ENDIF}

{$IFDEF VER250}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
{$ENDIF}

{$IFDEF VER260}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
{$ENDIF}

{$IFDEF VER270}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
{$ENDIF}

{$IFDEF VER280}
  {$DEFINE DELPHIXE}
  {$DEFINE DELPHIXE2}
  {$DEFINE DELPHIXE3}
  {$DEFINE DELPHIXE4}
  {$DEFINE DELPHIXE5}
  {$DEFINE DELPHIXE6}
  {$DEFINE DELPHIXE7}
{$ENDIF}

{$IF DEFINED(UNZIP) OR DEFINED(UNRAR)}
  {$DEFINE ARCHIVES}
{$IFEND}
