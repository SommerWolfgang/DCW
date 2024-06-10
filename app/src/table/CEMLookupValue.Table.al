table 6086347 "CEM Lookup Value"
{
    Caption = 'Lookup Value';
    DataCaptionFields = "Field Type Code";

    fields
    {
        field(1; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            NotBlank = true;
            TableRelation = "CEM Field Type";
        }
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(3; "Parent Field Type Code"; Code[50])
        {
            Caption = 'Parent Field Type Code';
        }
        field(4; Manual; Boolean)
        {
            Caption = 'Manual';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Field Type Code", "Parent Field Type Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        FieldType: Record "CEM Field Type";
    begin
        if Manual then begin
            FieldType.Get("Field Type Code");
            FieldType."Last Update Date/Time" := CurrentDateTime;
            FieldType.Modify;
        end;
    end;

    trigger OnInsert()
    var
        FieldType: Record "CEM Field Type";
    begin
        if Manual then begin
            FieldType.Get("Field Type Code");
            FieldType."Last Update Date/Time" := CurrentDateTime;
            FieldType.Modify;
        end;
    end;
}

