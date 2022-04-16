import { config, library, dom } from '@fortawesome/fontawesome-svg-core'

// Change the config to fix the flicker
config.mutateApproach = 'sync'

// Import required icons
import {
  faBan,
  faBarcode,
  faBars,
  faBook,
  faBuilding,
  faBug,
  faCalendar,
  faCircle,
  faCog,
  faComment,
  faCreditCard,
  faEdit,
  faEnvelope,
  faExclamationTriangle,
  faFax,
  faFile,
  faFilePdf,
  faFilter,
  faHome,
  faHospital,
  faKey,
  faLaptop,
  faLink,
  faList,
  faListAlt,
  faMedkit,
  faMapMarker,
  faMinusCircle,
  faMobileAlt,
  faMoneyCheck,
  faQuestionCircle,
  faPenSquare,
  faPlus,
  faPlusCircle,
  faPhone,
  faPhoneVolume,
  faRedo,
  faReply,
  faSave,
  faSearch,
  faSitemap,
  faSignOutAlt,
  faSpinner,
  faSuitcaseMedical,
  faTimes,
  faTrash,
  faUpload,
  faUser,
  faUserLock,
  faUserMd,
  faUsers,
  faUserSecret,
  faWrench
} from '@fortawesome/free-solid-svg-icons'

// add incons to library
library.add(
  faBan,
  faBarcode,
  faBars,
  faBook,
  faBuilding,
  faBug,
  faCalendar,
  faCircle,
  faCog,
  faComment,
  faCreditCard,
  faEdit,
  faEnvelope,
  faExclamationTriangle,
  faFax,
  faFile,
  faFilePdf,
  faFilter,
  faHome,
  faHospital,
  faKey,
  faLaptop,
  faLink,
  faList,
  faListAlt,
  faMedkit,
  faMapMarker,
  faMinusCircle,
  faMobileAlt,
  faMoneyCheck,
  faQuestionCircle,
  faPenSquare,
  faPlus,
  faPlusCircle,
  faPhone,
  faPhoneVolume,
  faRedo,
  faReply,
  faSave,
  faSearch,
  faSitemap,
  faSignOutAlt,
  faSpinner,
  faSuitcaseMedical,
  faTimes,
  faTrash,
  faUpload,
  faUser,
  faUserLock,
  faUserMd,
  faUsers,
  faUserSecret,
  faWrench
)

// watch hatml
dom.watch()
