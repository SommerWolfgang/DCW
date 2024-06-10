table 6086018 "CDC Delegation Sharing"
{
    Caption = 'Delegation Sharing';
    DataCaptionFields = "Owner User ID", "Shared to User ID";
    Permissions = TableData "CDC Approval Sharing" = rimd;

    fields
    {
        field(1; "Owner User ID"; Code[50])
        {
            Caption = 'Owner User ID';
            NotBlank = true;
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            begin
                if "Owner User ID" <> '' then
                    if "Owner User ID" = "Shared to User ID" then
                        Error(OwnerEqualSharedToErr, FieldCaption("Owner User ID"), FieldCaption("Shared to User ID"), "Owner User ID");
            end;
        }
        field(2; "Shared to User ID"; Code[50])
        {
            Caption = 'Shared to User ID';
            NotBlank = true;
            TableRelation = "CDC Continia User Setup";

            trigger OnValidate()
            begin
                if "Shared to User ID" <> '' then
                    if "Owner User ID" = "Shared to User ID" then
                        Error(OwnerEqualSharedToErr, FieldCaption("Owner User ID"), FieldCaption("Shared to User ID"), "Owner User ID");
            end;
        }
        field(4; "Valid From"; Date)
        {
            Caption = 'Valid From';

            trigger OnValidate()
            begin
                CheckValidDates;
            end;
        }
        field(5; "Valid To"; Date)
        {
            Caption = 'Valid To';

            trigger OnValidate()
            begin
                CheckValidDates;
            end;
        }
        field(7; "Display Order"; Integer)
        {
            Caption = 'Display Order';
        }
        field(9; "Copy to All Companies"; Boolean)
        {
            Caption = 'Copy to All Companies';

            trigger OnValidate()
            var
                DelegationSharing: Record "CDC Delegation Sharing";
            begin

                DelegationSharing := Rec;
                if not DelegationSharing.Find('=') then // only continue if the record is already inserted in the table
                    exit;
                if "Copy to All Companies" then
                    InsertInAllCompanies
                else begin
                    if Confirm(Text002, true, TableCaption) then
                        DeleteFromAllCompanies
                    else
                        ModifyInAllCompanies;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Owner User ID", "Shared to User ID", "Valid From", "Valid To")
        {
            Clustered = true;
        }
        key(Key2; "Shared to User ID", "Valid From", "Valid To")
        {
        }
        key(Key3; "Display Order")
        {
        }
    }
    var
        OwnerEqualSharedToErr: Label '%1 (%3) must not be equal to %2 (%3).';
        Text002: Label 'Do you want to delete this %1 from all other companies?';
        ValidDatesErr: Label '%1 is higher than %2.';


    procedure InsertInAllCompanies()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        DelegationlSharing: Record "CDC Delegation Sharing";
        DCSetup: Record "CDC Document Capture Setup";
        Company: Record Company;
    begin
        Company.SetFilter(Name, '<>%1', CompanyName);
        if Company.FindSet then
            repeat
                if DCSetup.ChangeCompany(Company.Name) then
                    if DCSetup.ReadPermission then
                        if DCSetup.Get and (DCSetup."Document Nos." <> '') then begin
                            if ContiniaUserSetup.ChangeCompany(Company.Name) then
                                if ContiniaUserSetup.Get("Owner User ID") and ContiniaUserSetup.Get("Shared to User ID") then begin
                                    if DelegationlSharing.ChangeCompany(Company.Name) then
                                        if not DelegationlSharing.Get("Owner User ID", "Shared to User ID", "Valid From", "Valid To") then begin
                                            DelegationlSharing := Rec;
                                            DelegationlSharing.Insert;
                                        end;
                                end;
                        end;
            until Company.Next = 0;
    end;


    procedure ModifyInAllCompanies()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        DelegationlSharing: Record "CDC Delegation Sharing";
        Company: Record Company;
    begin
        Company.SetFilter(Name, '<>%1', CompanyName);
        if Company.FindSet then
            repeat
                if DelegationlSharing.ChangeCompany(Company.Name) then
                    if DelegationlSharing.Get("Owner User ID", "Shared to User ID", "Valid From", "Valid To") then begin
                        DelegationlSharing."Display Order" := "Display Order";
                        DelegationlSharing."Copy to All Companies" := "Copy to All Companies";
                        DelegationlSharing.Modify;
                    end;
            until Company.Next = 0;
    end;


    procedure DeleteFromAllCompanies()
    var
        DelegationlSharing: Record "CDC Delegation Sharing";
        Company: Record Company;
    begin
        Company.SetFilter(Name, '<>%1', CompanyName);
        if Company.FindSet then
            repeat
                if DelegationlSharing.ChangeCompany(Company.Name) then
                    if DelegationlSharing.Get("Owner User ID", "Shared to User ID", "Valid From", "Valid To") then
                        DelegationlSharing.Delete;
            until Company.Next = 0;
    end;


    procedure RenameInAllCompanies()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        DelegationlSharing: Record "CDC Delegation Sharing";
        Company: Record Company;
    begin
        Company.SetFilter(Name, '<>%1', CompanyName);
        if Company.FindSet then
            repeat
                if DelegationlSharing.ChangeCompany(Company.Name) then begin
                    if DelegationlSharing.Get(xRec."Owner User ID", xRec."Shared to User ID", xRec."Valid From", xRec."Valid To")
                    then
                        DelegationlSharing.Delete;

                    if DelegationlSharing.Get("Owner User ID", "Shared to User ID", "Valid From", "Valid To") then
                        DelegationlSharing.Delete;

                    DelegationlSharing := Rec;
                    DelegationlSharing.Insert;
                end;
            until Company.Next = 0;
    end;

    local procedure CheckValidDates()
    begin
        if ("Valid From" = 0D) or ("Valid To" = 0D) then
            exit;
        if "Valid From" > "Valid To" then
            Error(ValidDatesErr, FieldCaption("Valid From"), FieldCaption("Valid To"));
    end;


    procedure DeleteAllOutOfOffice(DelegatedToUserId: Code[50]; DeleteInAllOtherCompanies: Boolean; ExcludeOption: Option "None",xRec,Rec)
    var
        DelegationlSharing: Record "CDC Delegation Sharing";
        Company: Record Company;
        doDelete: Boolean;
    begin
        DelegationlSharing.SetRange("Owner User ID", DelegatedToUserId);
        if not DelegationlSharing.IsEmpty then begin
            DelegationlSharing.FindSet;
            repeat
                case ExcludeOption of
                    ExcludeOption::None:
                        doDelete := true;
                    ExcludeOption::Rec:
                        doDelete := (Rec."Owner User ID" <> DelegationlSharing."Owner User ID") or
                                    (Rec."Shared to User ID" <> DelegationlSharing."Shared to User ID") or
                                    (Rec."Valid From" <> DelegationlSharing."Valid From") or
                                    (Rec."Valid To" <> DelegationlSharing."Valid To");
                    ExcludeOption::xRec:
                        doDelete := (xRec."Owner User ID" <> DelegationlSharing."Owner User ID") or
                                    (xRec."Shared to User ID" <> DelegationlSharing."Shared to User ID") or
                                    (xRec."Valid From" <> DelegationlSharing."Valid From") or
                                    (xRec."Valid To" <> DelegationlSharing."Valid To");
                end;
                if doDelete then
                    DelegationlSharing.Delete;
            until DelegationlSharing.Next = 0;
        end;
        if DeleteInAllOtherCompanies then begin
            Company.SetFilter(Name, '<>%1', CompanyName);
            if Company.FindSet then
                repeat
                    if DelegationlSharing.ChangeCompany(Company.Name) then begin
                        DelegationlSharing.SetRange("Owner User ID", DelegatedToUserId);
                        if not DelegationlSharing.IsEmpty then
                            DelegationlSharing.DeleteAll;
                    end;
                until Company.Next = 0;
        end;
    end;
}

