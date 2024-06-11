table 6086398 "CEM Default User Setup"
{
    Caption = 'Default Continia User Setup';

    fields
    {
        field(1; "Setup Type"; Option)
        {
            Caption = 'Setup Type';
            OptionCaption = 'User,Group';
            OptionMembers = User,Group;
        }
        field(2; "Code"; Code[50])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF ("Setup Type" = CONST(User)) "CDC Continia User Setup"
            ELSE
            IF ("Setup Type" = CONST(Group)) "CEM Expense User Group";
        }
        field(5; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
            TableRelation = "CEM Vehicle";
        }
        field(6; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
            TableRelation = "CEM Per Diem Group";
        }
        field(7; "Expense Reimbursement"; Option)
        {
            Caption = 'Expense Reimbursement';
            OptionCaption = ' ,Internal (on User),External Payroll System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;

            trigger OnValidate()
            begin
                UpdateExpReimbMethod;
            end;
        }
        field(8; "Mileage Reimbursement"; Option)
        {
            Caption = 'Mileage Reimbursement';
            OptionCaption = ' ,Internal (on User),External Payroll System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;

            trigger OnValidate()
            begin
                UpdateMilReimbMethod;
            end;
        }
        field(9; "Per Diem Reimbursement"; Option)
        {
            Caption = 'Per Diem Reimbursement';
            OptionCaption = ' ,Internal (on User),External Payroll System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;

            trigger OnValidate()
            begin
                UpdatePerDReimbMethod;
            end;
        }
    }

    keys
    {
        key(Key1; "Setup Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DefaultSetupNotFoundErr: Label 'User %1 must have a %2.';
        UpdatedExpUserGroupQst: Label 'User Group %1 has %2 unposted expenses.\\Do you want to update all unposted expenses and set Reimbursement Method to %3?';
        UpdatedExpUserQst: Label 'User %1 has %2 unposted expenses.\\Do you want to update all unposted expenses and set Reimbursement Method to %3?';
        UpdatedMilUserGroupQst: Label 'User Group %1 has %2 unposted mileage.\\Do you want to update all unposted mileage and set Reimbursement Method to %3?';
        UpdatedMilUserQst: Label 'User %1 has %2 unposted mileage.\\Do you want to update all unposted mileage and set Reimbursement Method to %3?';
        UpdatedPerDiemUserGroupQst: Label 'User Group %1 has %2 unposted per diems.\\Do you want to update all unposted per diems and set Reimbursement Method to %3?';
        UpdatedPerDiemUserQst: Label 'User %1 has %2 unposted per diems.\\Do you want to update all unposted per diems and set Reimbursement Method to %3?';


    procedure UpdateExpReimbMethod()
    var
        ContUserSetup: Record "CDC Continia User Setup";
        Expense: Record "CEM Expense";
        Confirmed: Boolean;
        TotalExpenses: Integer;
    begin
        if "Setup Type" = "Setup Type"::Group then
            ContUserSetup.SetRange("Expense User Group", Code)
        else
            ContUserSetup.SetRange("Continia User ID", Code);

        if ContUserSetup.IsEmpty then
            exit;

        if ContUserSetup.FindSet then
            repeat
                Expense.SetCurrentKey(Posted, "Continia User ID");
                Expense.SetRange(Posted, false);
                Expense.SetRange("Continia User ID", ContUserSetup."Continia User ID");
                TotalExpenses += Expense.Count;
            until ContUserSetup.Next = 0;

        if TotalExpenses = 0 then
            exit;

        if "Setup Type" = "Setup Type"::Group then
            Confirmed := Confirm(UpdatedExpUserGroupQst, true,
              Code, TotalExpenses, Format("Expense Reimbursement"))
        else
            Confirmed := Confirm(UpdatedExpUserQst, true,
              Code, TotalExpenses, Format("Expense Reimbursement"));

        if not Confirmed then
            exit;

        if ContUserSetup.FindSet then
            repeat
                Expense.SetCurrentKey(Posted, "Continia User ID");
                Expense.SetRange(Posted, false);
                Expense.SetRange("Continia User ID", ContUserSetup."Continia User ID");
                if Expense.FindSet then
                    repeat
                        Expense."Reimbursement Method" := "Expense Reimbursement" - 1; // The optionstrings are intentionally different
                        Expense.Modify;
                        CODEUNIT.Run(CODEUNIT::"CEM Expense-Validate", Expense);
                    until Expense.Next = 0;
            until ContUserSetup.Next = 0;
    end;


    procedure UpdateMilReimbMethod()
    var
        ContUserSetup: Record "CDC Continia User Setup";
        Mileage: Record "CEM Mileage";
        Confirmed: Boolean;
        TotalMileage: Integer;
    begin
        if "Setup Type" = "Setup Type"::Group then
            ContUserSetup.SetRange("Expense User Group", Code)
        else
            ContUserSetup.SetRange("Continia User ID", Code);

        if ContUserSetup.IsEmpty then
            exit;

        if ContUserSetup.FindSet then
            repeat
                Mileage.SetCurrentKey(Posted, "Continia User ID");
                Mileage.SetRange(Posted, false);
                Mileage.SetRange("Continia User ID", ContUserSetup."Continia User ID");
                TotalMileage += Mileage.Count;
            until ContUserSetup.Next = 0;

        if TotalMileage = 0 then
            exit;

        if "Setup Type" = "Setup Type"::Group then
            Confirmed := Confirm(UpdatedMilUserGroupQst, true,
              Code, TotalMileage, Format("Mileage Reimbursement"))
        else
            Confirmed := Confirm(UpdatedMilUserQst, true,
              Code, TotalMileage, Format("Mileage Reimbursement"));

        if not Confirmed then
            exit;

        if ContUserSetup.FindSet then
            repeat
                Mileage.SetCurrentKey(Posted, "Continia User ID");
                Mileage.SetRange(Posted, false);
                Mileage.SetRange("Continia User ID", ContUserSetup."Continia User ID");
                if Mileage.FindSet then
                    repeat
                        Mileage."Reimbursement Method" := "Mileage Reimbursement" - 1; // The optionstrings are intentionally different
                        Mileage.Modify;
                        CODEUNIT.Run(CODEUNIT::"CEM Mileage-Validate", Mileage);
                    until Mileage.Next = 0;
            until ContUserSetup.Next = 0;
    end;


    procedure UpdatePerDReimbMethod()
    var
        ContUserSetup: Record "CDC Continia User Setup";
        PerDiem: Record "CEM Per Diem";
        Confirmed: Boolean;
        TotalPerDiem: Integer;
    begin
        if "Setup Type" = "Setup Type"::Group then
            ContUserSetup.SetRange("Expense User Group", Code)
        else
            ContUserSetup.SetRange("Continia User ID", Code);

        if ContUserSetup.IsEmpty then
            exit;

        if ContUserSetup.FindSet then
            repeat
                PerDiem.SetCurrentKey(Posted, "Continia User ID");
                PerDiem.SetRange(Posted, false);
                PerDiem.SetRange("Continia User ID", ContUserSetup."Continia User ID");
                TotalPerDiem += PerDiem.Count;
            until ContUserSetup.Next = 0;

        if TotalPerDiem = 0 then
            exit;

        if "Setup Type" = "Setup Type"::Group then
            Confirmed := Confirm(UpdatedPerDiemUserGroupQst, true,
              Code, TotalPerDiem, Format("Per Diem Reimbursement"))
        else
            Confirmed := Confirm(UpdatedPerDiemUserQst, true,
              Code, TotalPerDiem, Format("Per Diem Reimbursement"));

        if not Confirmed then
            exit;

        if ContUserSetup.FindSet then
            repeat
                PerDiem.SetCurrentKey(Posted, "Continia User ID");
                PerDiem.SetRange(Posted, false);
                PerDiem.SetRange("Continia User ID", ContUserSetup."Continia User ID");
                if PerDiem.FindSet then
                    repeat
                        PerDiem."Reimbursement Method" := "Per Diem Reimbursement" - 1; // The optionstrings are intentionally different
                        PerDiem.Modify;
                        CODEUNIT.Run(CODEUNIT::"CEM Per Diem-Validate", PerDiem);
                    until PerDiem.Next = 0;
            until ContUserSetup.Next = 0;
    end;


    procedure GetExpReimbursMethodForUser(ContUserID: Code[50]): Integer
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        DefaultUserSetup: Record "CEM Default User Setup";
        EMUserGroup: Record "CEM Expense User Group";
    begin
        if not GetDefaultUserSetupForUser(ContUserID, DefaultUserSetup, false) then
            exit;

        DefaultUserSetup.TestField("Expense Reimbursement");
        exit(DefaultUserSetup."Expense Reimbursement" - 1); // Optionstrings are different
    end;


    procedure GetMilReimbursMethodForUser(ContUserID: Code[50]): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        if not GetDefaultUserSetupForUser(ContUserID, DefaultUserSetup, false) then
            exit;

        DefaultUserSetup.TestField("Mileage Reimbursement");
        exit(DefaultUserSetup."Mileage Reimbursement" - 1); // Optionstrings are different
    end;


    procedure GetPerDReimbursMethodForUser(ContUserID: Code[50]): Integer
    var
        DefaultUserSetup: Record "CEM Default User Setup";
    begin
        if not GetDefaultUserSetupForUser(ContUserID, DefaultUserSetup, false) then
            exit;

        DefaultUserSetup.TestField("Per Diem Reimbursement");
        exit(DefaultUserSetup."Per Diem Reimbursement" - 1); // Optionstrings are different
    end;


    procedure GetDefaultUserSetupForUser(ContUserID: Code[50]; var DefaultUserSetup: Record "CEM Default User Setup"; ShowError: Boolean) Found: Boolean
    var
        ContUserSetup: Record "CDC Continia User Setup";
    begin
        Clear(DefaultUserSetup);

        DefaultUserSetup.SetRange("Setup Type", DefaultUserSetup."Setup Type"::User);
        DefaultUserSetup.SetRange(Code, ContUserID);
        if DefaultUserSetup.FindFirst then
            Found := true;

        if not Found then begin
            ContUserSetup.Get(ContUserID);

            DefaultUserSetup.SetRange("Setup Type", DefaultUserSetup."Setup Type"::Group);
            DefaultUserSetup.SetRange(Code, ContUserSetup."Expense User Group");
            if DefaultUserSetup.FindFirst then
                Found := true;
        end;

        if (not Found) and ShowError then
            Error(DefaultSetupNotFoundErr, ContUserID, DefaultUserSetup.TableCaption);
    end;
}

