table 6086397 "CEM Per Diem Register"
{
    Caption = 'Register';
    PasteIsValid = false;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "CDC Continia User Setup";
        }
        field(3; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(10; "No. of Per Diem Entries"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Register No." = field("No.")));
            Caption = 'No. of Per Diem Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownPerDiemEntries();
            end;
        }
        field(11; "No. of Reimb. Entries"; Integer)
        {
            CalcFormula = count("CEM Per Diem" where("Reimbursement Register No." = field("No.")));
            Caption = 'No. of Reimbursed Per Diem Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownReimbEntries();
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure CreateRegEntry(): Integer
    begin
    end;

    procedure DrillDownPerDiemEntries()
    begin
    end;

    procedure DrillDownReimbEntries()
    begin
    end;
}