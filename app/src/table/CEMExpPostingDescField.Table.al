table 6086333 "CEM Exp. Posting Desc. Field"
{
    Caption = 'Posting Desc. Field';
    DataCaptionFields = "Field Type Code", "Field Description";

    fields
    {
        field(1; "Parameter No."; Integer)
        {
            Caption = 'Parameter No.';
        }
        field(10; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            TableRelation = "CEM Field Type";
        }
        field(11; "Field Description"; Text[50])
        {
            CalcFormula = lookup("CEM Field Type".Description where(Code = field("Field Type Code")));
            Caption = 'Field Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Parameter No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetPostingDesc(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer): Text[1024]
    begin
    end;

    procedure GetInvPostingDesc(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer): Text[1024]
    begin
    end;

    procedure PostProcessString(TableID: Integer; FieldID: Integer; String: Text[1024]): Text[1024]
    begin
    end;
}