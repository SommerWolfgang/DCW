table 6192773 "CDC Continia Company Setup"
{
    Caption = 'Continia Company Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Company GUID"; Guid)
        {
            Description = 'Obsolete(''Replaced by Continia Core Module'';Removed;''6.0'')';
            Editable = false;
        }
        field(3; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
            CharAllowed = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ+-';
        }
        field(4; "Client ID"; Code[20])
        {
            Description = 'Obsolete(''Replaced by Continia Core Module'';Removed;''6.0'')';
        }
        field(5; "Web Portal Code"; Code[20])
        {
            Caption = 'Web Portal Code';
            TableRelation = "CDC Continia Web Portal".Code;

            trigger OnValidate()
            var
                ContiniaUserSetup: Record "CDC Continia User Setup";
            begin
                Modify();

                if (xRec."Web Portal Code" <> '') and ("Web Portal Code" = '') then begin
                    ContiniaUserSetup.SetRange("Approval Client", ContiniaUserSetup."Approval Client"::"Continia Web Approval Portal");
                    if ContiniaUserSetup.FindSet(true, false) then
                        repeat
                            ContiniaUserSetup.SetApprovalClient(true);
                            ContiniaUserSetup.Modify();
                        until ContiniaUserSetup.Next() = 0;
                end;
            end;
        }
        field(6; "Exclude DB info.from activa."; Boolean)
        {
            Caption = 'Exclude database information from Activation';
            Description = 'Obsolete(''Replaced by Continia Core Module'';Removed;''6.0'')';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TestFieldErr: Label '%1 must have a value in %2 in Company %3: %4=%5. It cannot be zero or empty.';


    procedure TESTFIELDCompanyCode(Company: Text[50])
    begin
        if Company = CompanyName then
            TestField("Company Code")
        else
            if "Company Code" = '' then
                Error(TestFieldErr, FieldCaption("Company Code"), TableCaption, Company, FieldCaption("Primary Key"), "Primary Key");
    end;
}

