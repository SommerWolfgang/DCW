table 6085762 "CDC Table Filter Field"
{
    Caption = 'Table Filter Field';

    fields
    {
        field(1; "Table Filter GUID"; Guid)
        {
            Caption = 'Table Filter GUID';
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; "Value (Text)"; Text[250])
        {
            Caption = 'Value (Text)';
        }
        field(5; "Value (Integer)"; Integer)
        {
            Caption = 'Value (Integer)';
        }
        field(6; "Value (Date)"; Date)
        {
            Caption = 'Value (Date)';
        }
        field(7; "Value (Decimal)"; Decimal)
        {
            Caption = 'Value (Decimal)';
        }
        field(8; "Value (Boolean)"; Boolean)
        {
            Caption = 'Value (Boolean)';
        }
        field(9; "Filter Type"; Option)
        {
            Caption = 'Filter Type';
            OptionCaption = 'Fixed Filter,Document Field';
            OptionMembers = "Fixed Filter","Document Field";
        }
        field(10; "Template No."; Code[20])
        {
            Caption = 'Template No.';
            TableRelation = "CDC Template";
        }
        field(11; "Template Field Type"; Option)
        {
            Caption = 'Template Field Type';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
            TableRelation = "CDC Template Field".Type where("Template No." = field("Template No."));
        }
        field(12; "Template Field Code"; Code[20])
        {
            Caption = 'Template Field Code';
            TableRelation = "CDC Template Field".Code where("Template No." = field("Template No."),
                                                             Type = field("Template Field Type"));
        }
        field(13; "Filter View"; Text[250])
        {
            Caption = 'Filter View';
        }
    }

    keys
    {
        key(Key1; "Table Filter GUID", "Field No.")
        {
            Clustered = true;
        }
    }

    procedure SetValues(var Value: Text[250]; var FilterType: Option "Fixed Filter","Document Field"; TemplateNo: Code[20]; TempFieldType: Integer): Boolean
    begin
        Value := '';
    end;

    procedure GetValues(var Value: Text[250]; var FilterType: Option "Fixed Filter","Document Field")
    begin
        Value := '';
    end;
}