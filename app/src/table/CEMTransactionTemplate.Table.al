table 6086406 "CEM Transaction Template"
{
    Caption = 'Transaction Import Template';
    LookupPageID = "CEM Transaction Template List";

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
            TableRelation = "CEM Bank";

            trigger OnLookup()
            var
                Banks: Record "CEM Bank";
            begin
                if PAGE.RunModal(PAGE::"CEM Banks", Banks) = ACTION::LookupOK then begin
                    Rec.Bank := Banks.Code;
                    Rec."Bank Country/Region" := Banks."Country/Region Code";
                end;
            end;
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

            trigger OnLookup()
            begin
                LookupDateFormats;
            end;
        }
        field(30; "Decimal Format"; Text[10])
        {
            Caption = 'Decimal Format';

            trigger OnLookup()
            begin
                LookupDecimalFormats;
            end;
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

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        FieldMapping: Record "CEM Transaction Field Mapping";
        TemplateRules: Record "CEM Transaction Template Rules";
    begin
        FieldMapping.SetRange("Template Code", Code);
        FieldMapping.DeleteAll;

        TemplateRules.SetRange("Template Code", Code);
        TemplateRules.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestField(Code);
    end;

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
    var
        Template: Record "CEM Transaction Template";
    begin
        Template.SetRange(Bank, Bank.Code);
        Template.SetRange("Bank Country/Region", Bank."Country/Region Code");

        if Template.FindFirst then begin
            if Template.Count > 1 then
                if not (PAGE.RunModal(0, Template) = ACTION::LookupOK) then
                    exit;
        end else begin
            Template.Code := Bank.Code;
            if Bank."Country/Region Code" <> '' then
                Template.Code := Template.Code + '-' + Bank."Country/Region Code";
            Template.Bank := Bank.Code;
            Template.Name := Bank.Name;
            Template."Bank Country/Region" := Bank."Country/Region Code";
            Template.Insert;
        end;

        PAGE.Run(PAGE::"CEM Transaction Template Card", Template);
    end;


    procedure RunImportJournal()
    var
        Template: Record "CEM Transaction Template";
    begin
        Template.SetRange("File Format", Template."File Format"::CSV);

        if PAGE.RunModal(0, Template) = ACTION::LookupOK then
            PAGE.Run(PAGE::"CEM Transaction Journal Card", Template);
    end;

    local procedure LookupDecimalFormats()
    var
        TempDataFormats: Record "CEM Data Formats" temporary;
    begin
        TempDataFormats.LoadDecimalFormats;
        if PAGE.RunModal(PAGE::"CEM Decimal Format Lookup", TempDataFormats) = ACTION::LookupOK then
            Validate("Decimal Format", TempDataFormats.Code);
    end;

    local procedure LookupDateFormats()
    var
        TempDataFormats: Record "CEM Data Formats" temporary;
    begin
        TempDataFormats.LoadDateFormats;

        if PAGE.RunModal(PAGE::"CEM Date Format Lookup", TempDataFormats) = ACTION::LookupOK then
            Validate("Date Format", TempDataFormats.Pattern);
    end;


    procedure ReadCardNoFromFileName(var FileName: Text; var CardNumberValue: Text)
    var
        Journal: Record "CEM Transaction Journal";
        FileInformation: Codeunit "CDC File Information";
        Math: Codeunit "CEM Math";
        FileStream: InStream;
        LengthToRead: Integer;
        LastError: Text;
    begin
        ClearLastError;
        if not UploadIntoStream('', '', '', FileName, FileStream) then begin
            LastError := GetLastErrorText;
            if LastError <> '' then
                Error(LastError);
        end;

        FileName := FileInformation.GetFilenameWithoutExt(FileName);

        if FileName <> '' then begin
            if "Card No. Length" = 0 then
                LengthToRead := StrLen(FileName)
            else
                LengthToRead := Math.Min(StrLen(FileName), "Card No. Length");

            CardNumberValue := CopyStr(FileName, "Card No. Start", LengthToRead);
        end;
    end;


    procedure GetLocalDataCulture(): Text[10]
    var
        LocalizationMgt: Codeunit "CSC Localization Management";
    begin
        case LocalizationMgt.Localization of
            'AT':
                exit('de-AT');
            'AU':
                exit('en-AU');
            'BE':
                exit('nl-BE');
            'CH':
                exit('de-CH');
            'DE':
                exit('de-DE');
            'DK':
                exit('da-DK');
            'ES':
                exit('es-ES');
            'FR':
                exit('fr-FR');
            'GB', 'W1':
                exit('en-GB');
            'NA', 'US':
                exit('en-US');
            'NL':
                exit('nl-NL');
            'NO':
                exit('nb-NO');
            'NZ':
                exit('en-NZ');
            'SE':
                exit('sv-SE');
        end;
    end;
}

