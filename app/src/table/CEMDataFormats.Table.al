table 6086409 "CEM Data Formats"
{
    Caption = 'Data Formats';

    fields
    {
        field(1; Index; Integer)
        {
            Caption = 'Index';
        }
        field(2; Pattern; Text[10])
        {
            Caption = 'Pattern';
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; Example; Text[10])
        {
            Caption = 'Example';
        }
        field(5; "Code"; Text[10])
        {
            Caption = 'Code';
        }
    }

    keys
    {
        key(Key1; Index)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure LoadDateFormats()
    var
        TempDateFormats: Record "CEM Data Formats" temporary;
    begin
        Rec.DeleteAll;

        CreateDateLookupValue(Rec, 'yyyy-MM-dd', '2020-06-03', '');
        CreateDateLookupValue(Rec, 'yy-MM-dd', '20-06-03', '');
        CreateDateLookupValue(Rec, 'yyyy-MM-d', '2020-06-3', '');
        CreateDateLookupValue(Rec, 'yy-MM-d', '20-06-3', '');
        CreateDateLookupValue(Rec, 'yyyy-M-d', '2020-6-3', '');
        CreateDateLookupValue(Rec, 'yy-M-d', '20-6-3', '');

        CreateDateLookupValue(Rec, 'dd-MM-yyyy', '03-06-2020', '');
        CreateDateLookupValue(Rec, 'dd-MM-yy', '03-06-20', '');
        CreateDateLookupValue(Rec, 'd-MM-yyyy', '3-06-2020', '');
        CreateDateLookupValue(Rec, 'd-MM-yy', '3-06-20', '');
        CreateDateLookupValue(Rec, 'd-M-yyyy', '3-6-2020', '');
        CreateDateLookupValue(Rec, 'd-M-yy', '3-6-20', '');

        CreateDateLookupValue(Rec, 'dd.MM.yy', '03.06.20', '');
        CreateDateLookupValue(Rec, 'dd.MM.yyyy', '03.06.2020', '');
        CreateDateLookupValue(Rec, 'd.MM.yy', '3.06.20', '');
        CreateDateLookupValue(Rec, 'd.MM.yyyy', '3.06.2020', '');
        CreateDateLookupValue(Rec, 'd.M.yy', '3.6.20', '');
        CreateDateLookupValue(Rec, 'd.M.yyyy', '3.6.2020', '');

        CreateDateLookupValue(Rec, 'dd/MM/yy', '03/06/20', '');
        CreateDateLookupValue(Rec, 'dd/MM/yyyy', '03/06/2020', '');
        CreateDateLookupValue(Rec, 'd/MM/yy', '3/06/20', '');
        CreateDateLookupValue(Rec, 'd/MM/yyyy', '3/06/2020', '');
        CreateDateLookupValue(Rec, 'd/M/yy', '3/6/20', '');
        CreateDateLookupValue(Rec, 'd/M/yyyy', '3/6/2020', '');

        CreateDateLookupValue(Rec, 'M/d/yyyy', '6/3/20', '');

        Rec.FindFirst; // Set point to first value
    end;

    local procedure CreateDateLookupValue(var TempDateFormats: Record "CEM Data Formats" temporary; Pattern: Text[30]; Example: Text[30]; "Code": Text[10])
    begin
        Rec.Index := Rec.Index + 1;
        Rec.Pattern := Pattern;
        Rec.Example := Example;
        Rec.Code := Code;
        Rec.Insert;
    end;


    procedure LoadDecimalFormats()
    var
        TempDecimalFormats: Record "CEM Data Formats" temporary;
        Apostrophe: Char;
    begin
        Rec.DeleteAll;

        Apostrophe := 39;

        CreateDecimalLookupValue(Rec, 'da-DK', 'Danish (Denmark)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'nl-BE', 'Dutch (Belgium)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'nl-NL', 'Dutch (Netherlands)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'en-AU', 'English (Australia)', '1,234.56');
        CreateDecimalLookupValue(Rec, 'en-CA', 'English (Canada)', '1,234.56');
        CreateDecimalLookupValue(Rec, 'en-NZ', 'English (New Zealand)', '1,234.56');
        CreateDecimalLookupValue(Rec, 'en-GB', 'English (Great Britain)', '1,234.56');
        CreateDecimalLookupValue(Rec, 'en-US', 'English (United States)', '1,234.56');
        CreateDecimalLookupValue(Rec, 'fr-BE', 'French (Belgium)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'fr-FR', 'French (France)', '1 234,56');
        CreateDecimalLookupValue(Rec, 'fr-CH', 'French (Switzerland)', '1' + Format(Apostrophe, 0, '<CHAR>') + '234.56');
        CreateDecimalLookupValue(Rec, 'de-AT', 'German (Austria)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'de-DE', 'German (Germany)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'de-CH', 'German (Switzerland)', '1' + Format(Apostrophe, 0, '<CHAR>') + '234.56');
        CreateDecimalLookupValue(Rec, 'nb-NO', 'Norwegian, Bokmål (Norway)', '1 234,56');
        CreateDecimalLookupValue(Rec, 'es-ES', 'Spanish (Spain)', '1.234,56');
        CreateDecimalLookupValue(Rec, 'sv-SE', 'Swedish (Sweden)', '1.234,56');

        Rec.FindFirst; // Set point to first value
    end;

    local procedure CreateDecimalLookupValue(var TempDecimalFormats: Record "CEM Data Formats" temporary; "Code": Text; Description: Text; Example: Text)
    begin
        Rec.Index := Rec.Index + 1;
        Rec.Code := Code;
        Rec.Description := Description;
        Rec.Example := Example;

        Rec.Insert;
    end;
}

