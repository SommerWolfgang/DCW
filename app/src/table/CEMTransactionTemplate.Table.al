table 6086406 "CEM Transaction Template"
{
    Caption = 'Transaction Import Template';

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Bank; Code[10])
        {
            Caption = 'Bank';
        }
        field(4; "File Format"; Option)
        {
            Caption = 'Format';
            InitValue = CSV;
            OptionMembers = " ",CSV;
        }
        field(5; "Bank Country/Region"; Code[10])
        {
            Caption = 'Bank Country/Region';
        }
        field(6; "File Encoding"; Option)
        {
            Caption = 'Encoding';
            InitValue = WINDOWS;
            OptionMembers = "UTF-8","UTF-16",WINDOWS;
        }
        field(10; "No. of Header Lines"; Integer)
        {
            Caption = 'No. of Header Lines';
        }
        field(11; "Column Separator"; Option)
        {
            Caption = 'Column Separator';
            InitValue = Comma;
            OptionCaption = ',Semicolon,Comma,Custom,Tab';
            OptionMembers = ,Semicolon,Comma,Custom,Tab;
        }
        field(12; "Custom Column Separator"; Text[1])
        {
            Caption = 'Custom Column Separator';
        }
        field(16; "No. of Footer Lines"; Integer)
        {
            Caption = 'No. of Footer Lines';
        }
        field(20; "Date Format"; Text[30])
        {
            Caption = 'Date Format';
        }
        field(30; "Decimal Format"; Text[10])
        {
            Caption = 'Decimal Format';
        }
        field(31; "Decimal Format Text"; Text[30])
        {
            Caption = 'Decimal Format Text';
        }
        field(35; "Card No. In File Name"; Boolean)
        {
            Caption = 'Card No. In File Name';
        }
        field(36; "Card No. Start"; Integer)
        {
            Caption = 'Card No. Start';
            InitValue = 1;
            MinValue = 1;
        }
        field(37; "Card No. Length"; Integer)
        {
            BlankNumbers = BlankZero;
            Caption = 'Card No. Length';
        }
        field(40; "Debit Identifier"; Text[30])
        {
            Caption = 'Debit Identifier';
        }
        field(41; "Credit Identifier"; Text[30])
        {
            Caption = 'Credit Identifier';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    var
        DateIndex: Integer;
        DecimalIndex: Integer;
        ErrDefinitionInComplete: Label 'As a minimum the Card No., Posting Date and Amount must be mapped.';
        ErrorLoadingTxt: Label 'Error loading file.';
        PleaseSpecifyStartEndTxt: Label 'Please enter card no. start character and length.';


    procedure GetCodePage(): Integer
    begin
        case "File Encoding" of
            "File Encoding"::WINDOWS:
                exit(1252);
            "File Encoding"::"UTF-8":
                exit(65001);
            "File Encoding"::"UTF-16":
                exit(1200);
        end;
    end;


    procedure GetColumnSeperator(): Text[1]
    begin
        case "Column Separator" of
            "Column Separator"::Comma:
                exit(',');
            "Column Separator"::Semicolon:
                exit(';');
            "Column Separator"::Custom:
                exit("Custom Column Separator");
            "Column Separator"::Tab:
                exit(';');
        end;
    end;


    procedure IsFieldConfigured(FieldNo: Integer): Boolean
    var
        FieldMapping: Record "CEM Transaction Field Mapping";
    begin
        FieldMapping.SetRange("Template Code", Code);
        FieldMapping.SetRange("Journal Field No.", FieldNo);
        exit(not FieldMapping.IsEmpty);
    end;


    procedure ValidateDefinition()
    var
        FieldMapping: Record "CEM Transaction Field Mapping";
        Journal: Record "CEM Transaction Journal";
    begin
        TestField(Bank);
        TestField("File Format");

        if "Column Separator" = "Column Separator"::Custom then
            TestField("Custom Column Separator");

        FieldMapping.SetRange("Template Code", Code);

        FieldMapping.SetRange("Journal Field No.", Journal.FieldNo("Card No."));
        if FieldMapping.IsEmpty then
            Error(ErrDefinitionInComplete);

        FieldMapping.SetRange("Journal Field No.", Journal.FieldNo("Posting Date"));
        if FieldMapping.IsEmpty then
            Error(ErrDefinitionInComplete);

        FieldMapping.SetRange("Journal Field No.", Journal.FieldNo("Bank-Currency Amount"));
        if FieldMapping.IsEmpty then
            Error(ErrDefinitionInComplete);
    end;


    procedure RunCardPageOnBank(Bank: Record "CEM Bank")
    begin
    end;

    procedure RunImportJournal()
    begin
    end;

    procedure ReadCardNoFromFileName(var FileName: Text; var CardNumberValue: Text)
    begin
    end;

    procedure GetLocalDataCulture(): Text[10]
    begin
    end;
}