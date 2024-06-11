table 6086397 "CEM Per Diem Register"
{
    Caption = 'Register';
    LookupPageID = "CEM Per Diem Register";
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
            CalcFormula = Count("CEM Per Diem" WHERE("Register No." = FIELD("No.")));
            Caption = 'No. of Per Diem Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownPerDiemEntries;
            end;
        }
        field(11; "No. of Reimb. Entries"; Integer)
        {
            CalcFormula = Count("CEM Per Diem" WHERE("Reimbursement Register No." = FIELD("No.")));
            Caption = 'No. of Reimbursed Per Diem Entries';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                DrillDownReimbEntries;
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
    var
        EMReg: Record "CEM Per Diem Register";
    begin
        EMReg.LockTable;
        if EMReg.FindLast then
            EMReg."No." := EMReg."No." + 1
        else
            EMReg."No." := 1;
        EMReg.Init;
        EMReg."Creation Date" := Today;
        EMReg."User ID" := UserId;
        EMReg.Insert;
        exit(EMReg."No.");
    end;


    procedure DrillDownPerDiemEntries()
    var
        PerDiem: Record "CEM Per Diem";
        PostedPerDiemList: Page "CEM Posted Per Diems";
    begin
        PerDiem.SetCurrentKey("Register No.");
        PerDiem.SetRange("Register No.", "No.");

        PostedPerDiemList.SetShowAllPerDiemIncludingSttl;
        PostedPerDiemList.SetTableView(PerDiem);
        PostedPerDiemList.Run;
    end;


    procedure DrillDownReimbEntries()
    var
        PerDiem: Record "CEM Per Diem";
        PostedPerDiemList: Page "CEM Posted Per Diems";
    begin
        PerDiem.SetCurrentKey("Reimbursement Register No.");
        PerDiem.SetRange("Reimbursement Register No.", "No.");

        PostedPerDiemList.SetShowAllPerDiemIncludingSttl;
        PostedPerDiemList.SetTableView(PerDiem);
        PostedPerDiemList.Run;
    end;
}

