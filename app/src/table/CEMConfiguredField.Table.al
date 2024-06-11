table 6086346 "CEM Configured Field"
{
    // This table is obsolete and should not be used anymore.
    // It is only kept in order to not have desctuctive changes in BC.

    Caption = 'Configured Field';
    DataCaptionFields = "Field Code", "Field Description";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Expense,Mileage,Settlement,"Per Diem";
        }
        field(2; "Field Order"; Integer)
        {
            Caption = 'Field Order';
        }
        field(3; "Sub Type"; Option)
        {
            Caption = 'Sub Type';
            OptionMembers = " ",Detail;
        }
        field(10; "Field Code"; Code[20])
        {
            Caption = 'Field Code';
            NotBlank = true;
            TableRelation = "CEM Field Type";

            trigger OnValidate()
            var
                ConfigField: Record "CEM Configured Field";
                FieldType: Record "CEM Field Type";
            begin
            end;
        }
        field(11; "Field Description"; Text[50])
        {
            CalcFormula = lookup("CEM Field Type".Description where(Code = field("Field Code")));
            Caption = 'Field Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Sent to Continia Online"; Boolean)
        {
            Caption = 'Sent to Continia Online';
            Editable = false;
        }
        field(23; "Hide visibility by default"; Boolean)
        {
            Caption = 'Hide visibility by default';
        }
    }

    keys
    {
        key(Key1; Type, "Field Order")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ConfigField: Record "CEM Configured Field";
        EMSetup: Record "CEM Expense Management Setup";
        FieldType: Record "CEM Field Type";
    begin
    end;
}

