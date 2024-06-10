table 6085596 "CDC Temp. Document Line"
{
    Caption = 'Temp. Document Line';
    PasteIsValid = false;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Field Value 1"; Text[250])
        {
            Caption = 'Field Value 1';
        }
        field(3; "Field Value 2"; Text[250])
        {
            Caption = 'Field Value 2';
        }
        field(4; "Field Value 3"; Text[250])
        {
            Caption = 'Field Value 3';
        }
        field(5; "Field Value 4"; Text[250])
        {
            Caption = 'Field Value 4';
        }
        field(6; "Field Value 5"; Text[250])
        {
            Caption = 'Field Value 5';
        }
        field(7; "Field Value 6"; Text[200])
        {
            Caption = 'Field Value 6';
        }
        field(8; "Field Value 7"; Text[200])
        {
            Caption = 'Field Value 7';
        }
        field(9; "Field Value 8"; Text[200])
        {
            Caption = 'Field Value 8';
        }
        field(10; "Field Value 9"; Text[200])
        {
            Caption = 'Field Value 9';
        }
        field(11; "Field Value 10"; Text[200])
        {
            Caption = 'Field Value 10';
        }
        field(12; "Field Value 11"; Text[150])
        {
            Caption = 'Field Value 11';
        }
        field(13; "Field Value 12"; Text[150])
        {
            Caption = 'Field Value 12';
        }
        field(14; "Field Value 13"; Text[150])
        {
            Caption = 'Field Value 13';
        }
        field(15; "Field Value 14"; Text[150])
        {
            Caption = 'Field Value 14';
        }
        field(16; "Field Value 15"; Text[150])
        {
            Caption = 'Field Value 15';
        }
        field(17; "Field Value 16"; Text[100])
        {
            Caption = 'Field Value 16';
        }
        field(18; "Field Value 17"; Text[100])
        {
            Caption = 'Field Value 17';
        }
        field(19; "Field Value 18"; Text[100])
        {
            Caption = 'Field Value 18';
        }
        field(20; "Field Value 19"; Text[100])
        {
            Caption = 'Field Value 19';
        }
        field(21; "Field Value 20"; Text[100])
        {
            Caption = 'Field Value 20';
        }
        field(22; OK; Boolean)
        {
            Caption = 'OK';
        }
        field(23; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(24; "Template No."; Code[20])
        {
            Caption = 'Template No.';
        }
        field(25; "Page No."; Integer)
        {
            Caption = 'Page No.';
        }
        field(26; "Translate to Type"; Option)
        {
            Caption = 'Translate to Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(27; "Translate to No."; Code[20])
        {
            Caption = 'Translate to No.';
        }
        field(28; Skip; Boolean)
        {
            Caption = 'Skip';
        }
        field(30; "Create Comment"; Boolean)
        {
            Caption = 'Create Comment';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure UpdateTranslInfo()
    begin
    end;

    procedure ShowCard()
    begin
    end;

    procedure LookupTranslToNo(var Text: Text[1024]): Boolean
    begin
        Text := '';
    end;

    procedure ManuallyInsertLine(NewLineLineNo: Integer)
    begin
    end;

    procedure GetLastLineNo() LastLineNo: Integer
    begin
    end;

    procedure TestfieldNo()
    begin
    end;

    procedure ShowMatchSpec()
    begin
    end;

    procedure FillSortingBuffer()
    begin
    end;

    procedure AddMissLineToPurchDoc()
    begin
    end;

    procedure GetMatchedQtyOnDocLine(var TempDocumentLine: Record "CDC Temp. Document Line" temporary): Decimal
    begin

    end;
}