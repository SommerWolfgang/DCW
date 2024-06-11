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
            TableRelation = Integer where(Number = filter(1 .. 100));
        }
        field(10; "Journal Field No."; Integer)
        {
            Caption = 'Journal Field No.';
            InitValue = 2;
            TableRelation = Field."No." where(TableNo = const(6086410),
                                               "No." = filter(2 .. 19 | 22 .. 27 | 100 | 120 | 130 | 140 .. 141));
            ValuesAllowed = 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 27, 100, 120, 130, 140, 141;
        }
        field(11; "Journal Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = const(6086410),
                                                              "No." = field("Journal Field No.")));
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
    begin
    end;
}