table 6086407 "CEM Transaction Field Mapping"
{
    Caption = 'Transaction Import Field Mapping';

    fields
    {
        field(1; "Template Code"; Code[20])
        {
            Caption = 'Transaction Template';
            NotBlank = true;
            TableRelation = "CEM Transaction Template";
        }
        field(2; "Column No."; Integer)
        {
            Caption = 'Column No.';
            InitValue = 1;
            TableRelation = Integer WHERE(Number = FILTER(1 .. 100));
        }
        field(10; "Journal Field No."; Integer)
        {
            Caption = 'Journal Field No.';
            InitValue = 2;
            TableRelation = Field."No." WHERE(TableNo = CONST(6086410),
                                               "No." = FILTER(2 .. 19 | 22 .. 27 | 100 | 120 | 130 | 140 .. 141));
            ValuesAllowed = 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 27, 100, 120, 130, 140, 141;

            trigger OnLookup()
            var
                RecIDMgt: Codeunit "CDC Record ID Mgt.";
                Text: Text[250];
            begin
            end;
        }
        field(11; "Journal Field Name"; Text[30])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE(TableNo = CONST(6086410),
                                                              "No." = FIELD("Journal Field No.")));
            Caption = 'Journal Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Reverse sign"; Boolean)
        {
            Caption = 'Reverse sign';
        }
    }

    keys
    {
        key(Key1; "Template Code", "Column No.", "Journal Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure IsDecimal(): Boolean
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"CEM Transaction Journal", "Journal Field No.");
        exit(Field.Type = Field.Type::Decimal);
    end;


    procedure IsDate(): Boolean
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"CEM Transaction Journal", "Journal Field No.");
        exit(Field.Type = Field.Type::Date);
    end;


    procedure IsText(): Boolean
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"CEM Transaction Journal", "Journal Field No.");
        exit(Field.Type = Field.Type::Text);
    end;


    procedure IsCode(): Boolean
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"CEM Transaction Journal", "Journal Field No.");
        exit(Field.Type = Field.Type::Code);
    end;


    procedure IsInteger(): Boolean
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"CEM Transaction Journal", "Journal Field No.");
        exit(Field.Type = Field.Type::Integer);
    end;


    procedure IsAmountField(): Boolean
    var
        Journal: Record "CEM Transaction Journal";
    begin
        if "Journal Field No." in [Journal.FieldNo(Amount), Journal.FieldNo("Bank-Currency Amount")] then
            exit(true);
    end;


    procedure IsCurrencyCodeField(): Boolean
    var
        Journal: Record "CEM Transaction Journal";
    begin
        if "Journal Field No." in [Journal.FieldNo("Currency Code")] then
            exit(true);
    end;


    procedure GetFieldLength(): Integer
    var
        "Field": Record "Field";
    begin
        Field.Get(DATABASE::"CEM Transaction Journal", "Journal Field No.");
        if (Field.Type = Field.Type::Text) or (Field.Type = Field.Type::Code) then
            exit(Field.Len);
    end;


    procedure LookupField(): Integer
    var
        Journal: Record "CEM Transaction Journal";
        "Field": Record "Field";
        LookupField: Record "Field" temporary;
        NAVversionMgt: Codeunit "CEM NAV-version Mgt.";
    begin
        Field.SetRange(TableNo, DATABASE::"CEM Transaction Journal");
        Field.SetRange(Enabled, true);
        Field.SetRange(Class, Field.Class::Normal);

        if Field.FindSet then
            repeat
                if not (Field."No." in [Journal.FieldNo("Entry No."), Journal.FieldNo("Document Time"), Journal.FieldNo("Template Code")]) then begin
                    LookupField := Field;
                    LookupField.Insert;
                end;
            until Field.Next = 0;

        if LookupField.FindFirst then;

        if PAGE.RunModal(NAVversionMgt.GetFieldLookupPageID, LookupField) = ACTION::LookupOK then
            exit(LookupField."No.");
    end;
}

