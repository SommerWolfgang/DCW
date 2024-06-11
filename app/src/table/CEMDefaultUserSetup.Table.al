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
        }
        field(5; "Vehicle Code"; Code[20])
        {
            Caption = 'Vehicle Code';
        }
        field(6; "Per Diem Group Code"; Code[20])
        {
            Caption = 'Per Diem Group Code';
        }
        field(7; "Expense Reimbursement"; Option)
        {
            Caption = 'Expense Reimbursement';
            OptionCaption = ' ,Internal (on User),External Payroll System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;
        }
        field(8; "Mileage Reimbursement"; Option)
        {
            Caption = 'Mileage Reimbursement';
            OptionCaption = ' ,Internal (on User),External Payroll System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;
        }
        field(9; "Per Diem Reimbursement"; Option)
        {
            Caption = 'Per Diem Reimbursement';
            OptionCaption = ' ,Internal (on User),External Payroll System,Both';
            OptionMembers = " ","Vendor (on User)","External System",Both;
        }
    }

    keys
    {
        key(Key1; "Setup Type", "Code")
        {
            Clustered = true;
        }
    }
    procedure UpdateExpReimbMethod()
    begin
    end;

    procedure UpdateMilReimbMethod()
    begin
    end;

    procedure UpdatePerDReimbMethod()
    begin
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
    begin
    end;
}