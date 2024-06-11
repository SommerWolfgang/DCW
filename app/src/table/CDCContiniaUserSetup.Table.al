table 6086002 "CDC Continia User Setup"
{
    Caption = 'Continia User Setup';
    DataCaptionFields = "Continia User ID";
    Permissions = TableData "CDC Approval Sharing" = rid;

    fields
    {
        field(1; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = "CDC Continia User";
        }
        field(3; "Expense Management User"; Boolean)
        {
            Caption = 'Expense User';
        }
        field(4; "Approval Client"; Option)
        {
            Caption = 'Approval Client';
            OptionCaption = ' ,Windows Client,Web Client,Continia Web Approval Portal';
            OptionMembers = " ","Windows Client","Web Client","Continia Web Approval Portal";
        }
        field(5; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
        }
        field(6; "Employee Name"; Text[250])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(10; "Can Edit Posting Lines"; Boolean)
        {
            Caption = 'Can Edit Posting Lines';
        }
        field(11; "Document Search"; Option)
        {
            Caption = 'Document Search';
            OptionCaption = 'All documents,Own documents only';
            OptionMembers = "All documents","Own documents only";
        }
        field(13; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(21; "Approval Administrator"; Boolean)
        {
            Caption = 'Approval Administrator';
        }
        field(22; "Allow Force Registration"; Boolean)
        {
            Caption = 'Allow Force Registration';
        }
        field(28; "No. of Approval Groups"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CDC Approval User Group Member" WHERE("Continia User ID" = FIELD("Continia User ID")));
            Caption = 'No. of Approval Groups';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "No. of Approval Permissions"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CDC Continia User Permission" WHERE("Continia User ID" = FIELD("Continia User ID")));
            Caption = 'No. of Approval Permissions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(31; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Shared to this user"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CDC Approval Sharing" WHERE("Shared to User ID" = FIELD("Continia User ID")));
            Caption = 'Shared to this user';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Shared to other users"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count("CDC Approval Sharing" WHERE("Owner User ID" = FIELD("Continia User ID")));
            Caption = 'Shared to other users';
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "Expense User Group"; Code[20])
        {
            Caption = 'Expense User Group';
        }
        field(39; "Expense Reminder Code"; Code[10])
        {
            Caption = 'Expense Reminder Code';
        }
        field(40; "No. of Purch. Doc. for Appr."; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = FILTER(38),
                                                        "Approver ID" = FIELD("Continia User ID"),
                                                        Status = CONST(Open)));
            Caption = 'No. of Purch. Doc. for Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Expense Amount Approval Limit"; Decimal)
        {
            BlankZero = true;
            Caption = 'Expense Amount Approval Limit';
            DecimalPlaces = 0 : 0;
        }
        field(42; "Unlimited Expense Approval"; Boolean)
        {
            Caption = 'Unlimited Expense Approval';

            trigger OnValidate()
            begin
                if "Unlimited Expense Approval" then
                    "Expense Amount Approval Limit" := 0;

                if "Approval Client" = "Approval Client"::" " then
                    SetApprovalClient(true);
            end;
        }
        field(43; "No. of Expenses for Approval"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = FILTER(6086320),
                                                        "Approver ID" = FIELD("Continia User ID"),
                                                        Status = CONST(Open)));
            Caption = 'No. of Expenses for Approval';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Vendor Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("Vendor No.")));
            Caption = 'Vendor Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "4-eyes, 2nd Approver ID"; Code[50])
        {
            Caption = '4-eyes Approval, 2nd Approver ID';
        }
        field(61; "Corporate Credit Card"; Boolean)
        {
            Caption = 'Corporate Credit Card';
        }
        field(62; "Expense Approver ID"; Code[50])
        {
            Caption = 'Expense Approver ID';
        }
        field(63; "EM Synch Required"; Boolean)
        {
            Caption = 'Expense Management Synchronization Required';
        }
        field(70; "Distance from home to office"; Decimal)
        {
            Caption = 'Distance from home to office';
        }
        field(71; "Can Edit Approved Documents"; Boolean)
        {
            Caption = 'Can Edit Approved Documents';
        }
        field(72; "Limit Document Visibility"; Boolean)
        {
            Caption = 'Limit Document Visibility';
        }
    }

    keys
    {
        key(Key1; "Continia User ID")
        {
            Clustered = true;
        }
    }
    procedure ValidateContiniaUserID(NewUserID: Code[50])
    begin
    end;

    procedure LookupContiniaUser(var Text: Text[50]): Boolean
    begin
        Text := '';
    end;


    procedure GetSalesPurchCode(): Code[20]
    begin
    end;

    procedure GetSalesPurchName(): Text[250]
    begin
    end;

    procedure DrillDownSalesPurchName(): Text[250]
    begin
    end;

    procedure GetEmployeeName(): Text[250]
    begin
    end;

    procedure DrillDownEmployeeName(): Text[250]
    begin
    end;

    procedure GetName(): Text[250]
    begin
    end;

    procedure GetName2(ContiniaUserID: Code[50]): Text[250]
    begin
    end;

    procedure GetEmail(): Text[250]
    begin
    end;


    procedure UpdateContiniaUserField(FieldNumber: Integer; Value: Variant)
    begin
    end;

    procedure UpdateUserSetupField(FieldNumber: Integer; Value: Variant)
    begin
    end;

    procedure DrillDownPurchDocForApproval()
    begin
    end;

    procedure SuspendContiniaUserDelete(Suspend: Boolean)
    begin
    end;

    procedure SuspendUserSetupDelete(Suspend: Boolean)
    begin
    end;

    procedure SetHideUserDeleteConfirmation(NewHideUserDeleteConfirmation: Boolean)
    begin
    end;

    procedure ResendWelcomeEmail()
    var
        ContiniaUser: Record "CDC Continia User";
    begin
        ContiniaUser.ResendWelcomeEmail;
    end;


    procedure SendWelcomeEmailToSelected(var UserSelection: Record "CDC Continia User")
    var
        ContiniaUser: Record "CDC Continia User";
    begin
        ContiniaUser.SendWelcomeEmailToSelected(UserSelection);
    end;


    procedure HasCompanyAccess(CompName: Text[250]): Boolean
    var
        CompContiniaUserSetup: Record "CDC Continia User Setup";
    begin
        if CompName = CompanyName then
            exit(true);

        CompContiniaUserSetup.ChangeCompany(CompName);
        exit(CompContiniaUserSetup.Get("Continia User ID"));
    end;

    procedure CopyUserSetup(CopyToCompany: Text[250]; CopyToUserID: Code[50]; ForceValues: Boolean)
    begin
    end;

    procedure CopyGlobalApprovalSharings(ContiniaUserID: Code[50])
    begin
    end;

    procedure DeleteRelatedUserTables()
    begin
    end;

    local procedure GetIsStandardApprovalAdminUser(): Boolean
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        "Field": Record "Field";
        UserSetup: Record "User Setup";
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        if not Field.Get(DATABASE::"User Setup", ContiniaUserSetup.FieldNo("Approval Administrator")) then
            exit(false);

        if not UserSetup.Get("Continia User ID") then
            exit(false);

        RecRef.GetTable(UserSetup);
        FieldRef := RecRef.Field(ContiniaUserSetup.FieldNo("Approval Administrator"));
        exit(FieldRef.Value);
    end;

    procedure GetNoOfAppvlShareToThisUser(): Integer
    begin
    end;

    procedure GetNoOfAppvlShareToOtherUsers(): Integer
    begin
    end;

    procedure DrillDownAppvlShareToThisUser(CompName: Text[250])
    begin
    end;

    procedure DrillDownAppvlShareToOtherUser(CompName: Text[250])
    begin
    end;

    procedure GetNoOfApprovalGroupMembership(): Integer
    begin
    end;

    procedure GetNoOfApprovalPermissions(): Integer
    begin
    end;

    procedure SetCurrCompanyName(NewCompanyName: Text[250])
    begin
    end;

    procedure GetCurrCompanyName(): Text[250]
    begin
    end;

    procedure SetApprovalClient(DoValidate: Boolean)
    begin
    end;

    procedure SetControlAppearance(var CEMEnabled: Boolean; var DCEnabled: Boolean; var CEMEnabledApp: Boolean; var CEMMatchingNotRequired: Boolean; var CEMShowEmployeeNo: Boolean; var CEMShowAddressSetup: Boolean; var ShowApproval: Boolean; var ShowDCOnlyApproval: Boolean; var ShowWebApproval: Boolean; var ShowApprovalClientApp: Boolean; var ShowApprovalClient: Boolean)
    begin
    end;

    procedure CanEditPendingDocuments(InputUserID: Code[50]): Boolean
    begin
    end;

    procedure CanEditApprovedDocuments(InputUserID: Code[50]): Boolean
    begin
    end;

    procedure GetActivationLink(): Text[250]
    begin
    end;

    procedure GetSendWelcomeEmail(): Boolean
    begin
    end;

    procedure GetActivationLinkEM(): Text[250]
    begin
    end;

    procedure GetSendWelcomeEmailEM(): Boolean
    begin
    end;
}