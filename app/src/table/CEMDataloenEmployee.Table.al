table 6086342 "CEM Dataloen Employee"
{
    Caption = 'Dataloen Employee';

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
            TableRelation = "CDC Continia User Setup" where("Expense Management User" = const(true));
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
}