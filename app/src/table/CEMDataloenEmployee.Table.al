table 6086342 "CEM Dataloen Employee"
{
    Caption = 'Dataloen Employee';
    LookupPageID = "CEM Expense by User Part";

    fields
    {
        field(1; "Employee ID"; Text[30])
        {
            Caption = 'Employee ID';
            NotBlank = true;
        }
        field(2; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
            NotBlank = true;
        }
        field(3; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup" WHERE ("Expense Management User" = CONST (true));

            trigger OnValidate()
            var
                DLEmployee: Record "CEM Dataloen Employee";
                UserDelegation: Record "CEM User Delegation";
            begin
                if "Continia User ID" = '' then
                    exit;

                UserDelegation.VerifyUser("Continia User ID");

                DLEmployee.SetCurrentKey("Continia User ID");
                DLEmployee.SetFilter("Continia User ID", "Continia User ID");
                if DLEmployee.FindFirst then
                    Error(ContiniaUserAllreadyMapped, "Continia User ID", DLEmployee."Employee ID", DLEmployee."Employee Name");
            end;
        }
    }

    keys
    {
        key(Key1; "Employee ID")
        {
            Clustered = true;
        }
        key(Key2; "Continia User ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ContiniaUserAllreadyMapped: Label 'Continia User %1 already mapped with Dataløn user %2 %3.\\Only one mapping is allowed.';
}

